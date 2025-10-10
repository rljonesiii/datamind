#!/usr/bin/env python3
"""
Interactive Neo4j Credential Helper

This script helps you test and update Neo4j credentials interactively.
"""

import getpass
import os
import sys

from dotenv import load_dotenv


def test_credentials(uri, user, password):
    """Test Neo4j credentials"""
    try:
        from neo4j import GraphDatabase
        driver = GraphDatabase.driver(uri, auth=(user, password))
        with driver.session() as session:
            result = session.run("RETURN 'Connected successfully!' as message")
            message = result.single()['message']
            driver.close()
            return True, message
    except Exception as e:
        return False, str(e)

def update_env_file(user, password):
    """Update the .env file with new credentials"""
    env_path = '.env'
    
    if not os.path.exists(env_path):
        print(f"❌ .env file not found at {env_path}")
        return False
    
    # Read current .env file
    with open(env_path, 'r') as f:
        lines = f.readlines()
    
    # Update credentials
    updated_lines = []
    user_updated = False
    password_updated = False
    
    for line in lines:
        if line.startswith('NEO4J_USER='):
            updated_lines.append(f'NEO4J_USER={user}\n')
            user_updated = True
        elif line.startswith('NEO4J_PASSWORD='):
            updated_lines.append(f'NEO4J_PASSWORD={password}\n')
            password_updated = True
        else:
            updated_lines.append(line)
    
    # Add missing entries
    if not user_updated:
        updated_lines.append(f'NEO4J_USER={user}\n')
    if not password_updated:
        updated_lines.append(f'NEO4J_PASSWORD={password}\n')
    
    # Write back to file
    with open(env_path, 'w') as f:
        f.writelines(updated_lines)
    
    print(f"✅ Updated .env file with new credentials")
    return True

def interactive_credential_helper():
    """Interactive credential testing and setup"""
    
    load_dotenv()
    
    uri = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
    current_user = os.getenv('NEO4J_USER', 'neo4j')
    current_password = os.getenv('NEO4J_PASSWORD', '')
    
    print("🔐 Interactive Neo4j Credential Helper")
    print("=" * 50)
    print(f"URI: {uri}")
    print(f"Current user: {current_user}")
    print(f"Current password: {'*' * len(current_password) if current_password else 'NOT SET'}")
    print()
    
    # Test current credentials first
    if current_password:
        print("🔄 Testing current credentials...")
        success, result = test_credentials(uri, current_user, current_password)
        if success:
            print(f"✅ Current credentials work! {result}")
            return True
        else:
            print(f"❌ Current credentials failed: {result.split('.')[0]}")
    
    print("\n📝 Let's try new credentials...")
    
    while True:
        print("\nOptions:")
        print("1. Enter credentials manually")
        print("2. Try common passwords")
        print("3. Exit")
        
        choice = input("\nChoice (1-3): ").strip()
        
        if choice == "1":
            user = input(f"Username [{current_user}]: ").strip() or current_user
            password = getpass.getpass("Password: ")
            
            print("🔄 Testing credentials...")
            success, result = test_credentials(uri, user, password)
            
            if success:
                print(f"✅ SUCCESS! {result}")
                
                update_choice = input("Update .env file with these credentials? (y/n): ").strip().lower()
                if update_choice in ['y', 'yes']:
                    update_env_file(user, password)
                
                return True
            else:
                print(f"❌ Failed: {result.split('.')[0]}")
                
        elif choice == "2":
            common_passwords = [
                "password",
                "admin", 
                "123456",
                "test",
                "neo4jpassword",
                "desktop",
                ""
            ]
            
            for password in common_passwords:
                desc = f"'{password}'" if password else "empty password"
                print(f"🔄 Trying {desc}...")
                
                success, result = test_credentials(uri, current_user, password)
                if success:
                    print(f"✅ SUCCESS with {desc}! {result}")
                    
                    update_choice = input("Update .env file with these credentials? (y/n): ").strip().lower()
                    if update_choice in ['y', 'yes']:
                        update_env_file(current_user, password)
                    
                    return True
                else:
                    print(f"❌ Failed with {desc}")
            
            print("❌ None of the common passwords worked")
            
        elif choice == "3":
            print("👋 Exiting...")
            return False
        else:
            print("❌ Invalid choice")

if __name__ == "__main__":
    success = interactive_credential_helper()
    
    if success:
        print("\n🎉 Neo4j credentials are working!")
        print("💡 You can now run DSAssist with Neo4j knowledge graph support")
    else:
        print("\n❌ Could not establish Neo4j connection")
        print("💡 Check Neo4j Desktop and ensure the database is started")
    
    sys.exit(0 if success else 1)