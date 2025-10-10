#!/usr/bin/env python3
"""
Neo4j Connection Test Script

Tests the connection to your Neo4j database using the credentials from .env
"""

import os
import sys

from dotenv import load_dotenv
from neo4j import GraphDatabase


def test_neo4j_connection():
    """Test Neo4j database connection and basic operations"""
    
    # Load environment variables
    load_dotenv()
    
    uri = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
    user = os.getenv('NEO4J_USER', 'neo4j')
    password = os.getenv('NEO4J_PASSWORD', '')
    
    print("🔍 Neo4j Connection Test")
    print("=" * 40)
    print(f"URI: {uri}")
    print(f"User: {user}")
    print(f"Password: {'*' * len(password) if password else 'NOT SET'}")
    print()
    
    if not password:
        print("❌ NEO4J_PASSWORD not set in .env file")
        return False
    
    try:
        print("🔗 Attempting to connect to Neo4j...")
        
        # Create driver
        driver = GraphDatabase.driver(uri, auth=(user, password))
        
        # Test connection with a simple query
        with driver.session() as session:
            # Test basic connectivity
            result = session.run("RETURN 'Connected!' as message")
            record = result.single()
            print(f"✅ Connection successful: {record['message']}")
            
            # Get database info
            result = session.run("CALL dbms.components() YIELD name, versions")
            components = list(result)
            if components:
                for component in components:
                    print(f"📋 {component['name']}: {component['versions'][0]}")
            
            # Test write permissions
            print("\n🔧 Testing write permissions...")
            session.run("""
                MERGE (test:DSAssistTest {id: 'connection_test'})
                SET test.timestamp = datetime()
                RETURN test
            """)
            print("✅ Write test successful")
            
            # Clean up test node
            session.run("MATCH (test:DSAssistTest {id: 'connection_test'}) DELETE test")
            print("🧹 Cleanup completed")
            
            # Check existing DSAssist data
            print("\n📊 Checking for existing DSAssist data...")
            result = session.run("MATCH (n) WHERE any(label IN labels(n) WHERE label STARTS WITH 'DSAssist') RETURN count(n) as count")
            count = result.single()['count']
            print(f"📈 Found {count} existing DSAssist nodes")
            
        driver.close()
        print("\n🎉 Neo4j connection test PASSED!")
        return True
        
    except Exception as e:
        print(f"❌ Connection failed: {str(e)}")
        print("\n🔧 Troubleshooting tips:")
        print("1. Check if Neo4j is running: neo4j status")
        print("2. Verify credentials are correct")
        print("3. Check firewall/network settings")
        print("4. Ensure Neo4j is listening on the specified port")
        return False

if __name__ == "__main__":
    success = test_neo4j_connection()
    sys.exit(0 if success else 1)