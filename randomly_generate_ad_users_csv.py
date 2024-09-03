import csv
import random
import faker
from datetime import datetime

# Initialize Faker to generate random user data
fake = faker.Faker()

# Define possible values for organizational units, groups, departments, titles, and office locations
organizational_units = ['TestOU', 'SalesOU', 'HR_OU', 'IT_OU', 'FinanceOU', 'MarketingOU']
groups = {
    'TestOU': ['TestGroup1', 'TestGroup2', 'TestGroup3'],
    'SalesOU': ['SalesGroup1', 'SalesGroup2', 'SalesGroup3'],
    'HR_OU': ['HRGroup1', 'HRGroup2', 'HRGroup3'],
    'IT_OU': ['ITGroup1', 'ITGroup2', 'ITGroup3'],
    'FinanceOU': ['FinanceGroup1', 'FinanceGroup2', 'FinanceGroup3'],
    'MarketingOU': ['MarketingGroup1', 'MarketingGroup2', 'MarketingGroup3']
}
departments = {
    'IT': ['Developer', 'System Administrator', 'Network Engineer', 'Data Analyst'],
    'HR': ['HR Manager', 'HR Specialist', 'Recruiter', 'HR Coordinator'],
    'Finance': ['Financial Analyst', 'Accountant', 'Finance Manager', 'Budget Analyst'],
    'Marketing': ['Marketing Manager', 'Content Strategist', 'SEO Specialist', 'Marketing Coordinator'],
    'Sales': ['Sales Executive', 'Account Manager', 'Sales Representative', 'Sales Associate'],
    'Test': ['Test Engineer', 'Quality Assurance', 'Test Manager']
}
offices = ['New York', 'Los Angeles', 'San Francisco', 'Chicago', 'Miami', 'Dallas', 'Seattle', 'Boston', 'Denver', 'Atlanta']

# Generate a random number of users (between 15 and 30)
num_users = random.randint(15, 30)

# Define the output CSV file path with a timestamp
timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
output_csv = f'random_users_{timestamp}.csv'

# Function to generate a random user
def generate_user():
    first_name = fake.first_name()
    last_name = fake.last_name()
    username = first_name[0].lower() + last_name.lower()
    password = 'P@ssword123'
    organizational_unit = random.choice(organizational_units)
    
    # Determine the department and corresponding job titles based on OU
    if 'IT' in organizational_unit:
        department = 'IT'
    elif 'HR' in organizational_unit:
        department = 'HR'
    elif 'Finance' in organizational_unit:
        department = 'Finance'
    elif 'Marketing' in organizational_unit:
        department = 'Marketing'
    elif 'Sales' in organizational_unit:
        department = 'Sales'
    else:
        department = 'Test'
    
    title = random.choice(departments[department])
    user_groups = ';'.join(random.sample(groups[organizational_unit], random.randint(1, 2)))
    office = random.choice(offices)
    
    return {
        'FirstName': first_name,
        'LastName': last_name,
        'Username': username,
        'Password': password,
        'OrganizationalUnit': organizational_unit,
        'Groups': user_groups,
        'Department': department,
        'Title': title,
        'Office': office
    }

# Generate the user data and write it to the CSV file
with open(output_csv, mode='w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=['FirstName', 'LastName', 'Username', 'Password', 'OrganizationalUnit', 'Groups', 'Department', 'Title', 'Office'])
    writer.writeheader()
    
    for _ in range(num_users):
        user_data = generate_user()
        writer.writerow(user_data)

print(f'Successfully generated {num_users} random users and saved to {output_csv}')