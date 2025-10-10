#!/usr/bin/env python3
"""
Neo4j Diagnostic Script

Comprehensive diagnostics for Neo4j connection issues
"""

import os
import socket
import sys

from dotenv import load_dotenv


def test_network_connectivity(host, port):
    """Test if the Neo4j port is reachable"""
    try:
        socket.create_connection((host, port), timeout=5)
        return True
    except (socket.timeout, socket.error):
        return False

def diagnose_neo4j():
    """Run comprehensive Neo4j diagnostics"""
    
    # Load environment variables
    load_dotenv()
    
    uri = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
    user = os.getenv('NEO4J_USER', 'neo4j')
    password = os.getenv('NEO4J_PASSWORD', '')
    
    print("🔍 Neo4j Diagnostic Report")
    print("=" * 50)
    
    # Parse URI
    if uri.startswith('bolt://'):
        host_port = uri.replace('bolt://', '')
        if ':' in host_port:
            host, port = host_port.split(':')
            port = int(port)
        else:
            host = host_port
            port = 7687
    else:
        print(f"❌ Unsupported URI format: {uri}")
        return False
    
    print(f"🌐 Target: {host}:{port}")
    print(f"👤 User: {user}")
    print(f"🔑 Password: {'✅ Set' if password else '❌ Not set'}")
    print()
    
    # Test 1: Environment variables
    print("📋 Step 1: Environment Variables")
    if not password:
        print("❌ NEO4J_PASSWORD is not set or empty")
        print("💡 Solution: Set NEO4J_PASSWORD in your .env file")
        return False
    else:
        print("✅ All required environment variables are set")
    print()
    
    # Test 2: Network connectivity
    print("📋 Step 2: Network Connectivity")
    if test_network_connectivity(host, port):
        print(f"✅ Can reach {host}:{port}")
    else:
        print(f"❌ Cannot reach {host}:{port}")
        print("💡 Possible solutions:")
        print("   - Check if Neo4j is running")
        print("   - Verify the host and port are correct")
        print("   - Check firewall settings")
        return False
    print()
    
    # Test 3: Try connection with neo4j driver
    print("📋 Step 3: Neo4j Driver Connection")
    try:
        from neo4j import GraphDatabase

        # Test with different authentication scenarios
        test_scenarios = [
            ("Current credentials", user, password),
            ("Default neo4j/neo4j", "neo4j", "neo4j"),
            ("Default neo4j/password", "neo4j", "password"),
        ]
        
        for scenario_name, test_user, test_password in test_scenarios:
            print(f"🔄 Testing {scenario_name} ({test_user})")
            try:
                driver = GraphDatabase.driver(f"bolt://{host}:{port}", auth=(test_user, test_password))
                with driver.session() as session:
                    result = session.run("RETURN 1")
                    result.single()
                print(f"✅ {scenario_name} works!")
                driver.close()
                
                if scenario_name != "Current credentials":
                    print(f"💡 Update your .env file with: NEO4J_USER={test_user}")
                    print(f"💡 Update your .env file with: NEO4J_PASSWORD={test_password}")
                
                return True
                
            except Exception as e:
                print(f"❌ {scenario_name} failed: {str(e).split('.')[0]}")
                if hasattr(driver, 'close'):
                    driver.close()
        
    except ImportError:
        print("❌ Neo4j driver not available")
        print("💡 Install with: pip install neo4j")
        return False
    except Exception as e:
        print(f"❌ Driver test failed: {e}")
    
    print()
    print("🔧 Troubleshooting Recommendations:")
    print("1. Verify Neo4j is running:")
    print("   neo4j status")
    print("2. Check Neo4j logs:")
    print("   tail -f /var/log/neo4j/neo4j.log")
    print("3. Reset Neo4j password:")
    print("   neo4j-admin set-initial-password <new-password>")
    print("4. Check Neo4j configuration:")
    print("   neo4j.conf - look for dbms.default_listen_address")
    
    return False

if __name__ == "__main__":
    success = diagnose_neo4j()
    sys.exit(0 if success else 1)