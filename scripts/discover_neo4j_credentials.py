#!/usr/bin/env python3
"""
Neo4j Password Discovery and Testing Script

This script will help identify the correct Neo4j credentials and test the connection.
"""

import os
import sys
import time

from dotenv import load_dotenv


def test_neo4j_with_credentials(uri, user, password):
    """Test Neo4j connection with specific credentials"""
    try:
        from neo4j import GraphDatabase
        driver = GraphDatabase.driver(uri, auth=(user, password))
        with driver.session() as session:
            result = session.run("RETURN 'success' as status")
            record = result.single()
            driver.close()
            return True, record['status']
    except Exception as e:
        return False, str(e)

def discover_neo4j_credentials():
    """Try to discover working Neo4j credentials"""
    
    load_dotenv()
    
    uri = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
    current_user = os.getenv('NEO4J_USER', 'neo4j')
    current_password = os.getenv('NEO4J_PASSWORD', '')
    
    print("🔍 Neo4j Credential Discovery")
    print("=" * 50)
    print(f"URI: {uri}")
    print()
    
    # Common Neo4j Desktop and default passwords to try
    credential_combinations = [
        (current_user, current_password, "Current .env credentials"),
        ("neo4j", "neo4j", "Default neo4j/neo4j"),
        ("neo4j", "password", "Common neo4j/password"),
        ("neo4j", "admin", "Common neo4j/admin"),
        ("neo4j", "123456", "Common neo4j/123456"),
        ("neo4j", "test", "Common neo4j/test"),
        ("neo4j", "", "Empty password"),
        ("neo4j", "neo4jpassword", "Neo4j Desktop default"),
        ("neo4j", "desktop", "Neo4j Desktop alt"),
    ]
    
    successful_credentials = []
    
    for user, password, description in credential_combinations:
        if not password and description != "Empty password":
            continue
            
        print(f"🔄 Testing {description} ({user}:{'*' * len(password) if password else 'empty'})")
        
        success, result = test_neo4j_with_credentials(uri, user, password)
        
        if success:
            print(f"✅ SUCCESS: {description}")
            successful_credentials.append((user, password, description))
        else:
            error_type = result.split('.')[0] if '.' in result else result
            print(f"❌ Failed: {error_type}")
        
        time.sleep(0.1)  # Small delay to be nice to the server
    
    print("\n" + "=" * 50)
    
    if successful_credentials:
        print("🎉 Found working credentials!")
        for user, password, desc in successful_credentials:
            print(f"✅ {desc}: {user} / {password}")
            
        # Update .env file suggestion
        best_creds = successful_credentials[0]
        print(f"\n💡 To update your .env file:")
        print(f"NEO4J_USER={best_creds[0]}")
        print(f"NEO4J_PASSWORD={best_creds[1]}")
        
        return True, best_creds[0], best_creds[1]
    else:
        print("❌ No working credentials found")
        print("\n🔧 Next steps:")
        print("1. Open Neo4j Desktop")
        print("2. Check your database credentials")
        print("3. Try resetting the password")
        print("4. Check if the database is actually started")
        
        return False, None, None

def test_knowledge_graph_operations(user, password):
    """Test DSAssist-specific knowledge graph operations"""
    
    uri = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
    
    print("\n🧪 Testing DSAssist Knowledge Graph Operations")
    print("=" * 50)
    
    try:
        from neo4j import GraphDatabase
        driver = GraphDatabase.driver(uri, auth=(user, password))
        
        with driver.session() as session:
            # Test 1: Create experiment node
            print("📝 Test 1: Creating experiment node...")
            session.run("""
                MERGE (exp:DSAssistExperiment {id: 'test-experiment'})
                SET exp.research_question = 'Test connection to Neo4j',
                    exp.created_at = datetime(),
                    exp.status = 'testing'
                RETURN exp.id as id
            """)
            print("✅ Experiment node created")
            
            # Test 2: Create iteration nodes
            print("📝 Test 2: Creating iteration nodes...")
            session.run("""
                MATCH (exp:DSAssistExperiment {id: 'test-experiment'})
                MERGE (iter:DSAssistIteration {experiment_id: 'test-experiment', iteration: 1})
                SET iter.success = true,
                    iter.metrics = {correlation: 0.85},
                    iter.timestamp = datetime()
                MERGE (exp)-[:HAS_ITERATION]->(iter)
                RETURN iter.iteration as iteration
            """)
            print("✅ Iteration node created with relationship")
            
            # Test 3: Query data
            print("📝 Test 3: Querying experiment data...")
            result = session.run("""
                MATCH (exp:DSAssistExperiment)-[:HAS_ITERATION]->(iter:DSAssistIteration)
                WHERE exp.id = 'test-experiment'
                RETURN exp.research_question as question, iter.metrics as metrics
            """)
            
            for record in result:
                print(f"   Research Question: {record['question']}")
                print(f"   Metrics: {record['metrics']}")
            
            # Test 4: Clean up
            print("📝 Test 4: Cleaning up test data...")
            session.run("""
                MATCH (exp:DSAssistExperiment {id: 'test-experiment'})
                DETACH DELETE exp
            """)
            session.run("""
                MATCH (iter:DSAssistIteration {experiment_id: 'test-experiment'})
                DELETE iter
            """)
            print("✅ Test data cleaned up")
            
        driver.close()
        print("\n🎉 All knowledge graph operations successful!")
        return True
        
    except Exception as e:
        print(f"❌ Knowledge graph test failed: {e}")
        return False

if __name__ == "__main__":
    # Step 1: Discover credentials
    success, user, password = discover_neo4j_credentials()
    
    if success:
        # Step 2: Test DSAssist operations
        kg_success = test_knowledge_graph_operations(user, password)
        sys.exit(0 if kg_success else 1)
    else:
        sys.exit(1)