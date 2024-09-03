import csv
import random
import faker

# Initialize Faker to generate random user data
fake = faker.Faker()

# Define possible values for organizational units, groups, departments, titles, and office locations
organizational_units = ['TestOU', 'SalesOU', 'HR_OU']
groups = {
    'TestOU': ['TestGroup1', 'TestGroup2', 'TestGroup3'],
    'SalesOU': ['SalesGroup1', 'SalesGroup2', 'SalesGroup3'],
    'HR_OU': ['HRGroup1', 'HRGroup2', 'HRGroup3']
}
departments = ['IT', 'HR', 'Finance', 'Marketing', 'Sales']
titles = ['Developer', 'Manager', 'Analyst', 'Coordinator', 'Executive', 'Sales Associate', 'HR Specialist']
offices = ['NYC', 'LA', 'SF', 'TX']

# Generate a random number of users (between 15 and 30)
num_users = random.randint(15, 30)

# Define the output CSV file path
output_csv = 'random_users.csv'

# Function to generate a random user
def generate_user():
    first_name = fake.first_name()
    last_name = fake.last_name()
    username = first_name[0].lower() + last_name.lower()
    password = 'P@ssword123'
    organizational_unit = random.choice(organizational_units)
    user_groups = ';'.join(random.sample(groups[organizational_unit], random.randint(1, 2)))
    department = random.choice(departments)
    title = random.choice(titles)
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
