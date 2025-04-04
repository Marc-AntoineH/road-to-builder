import json
import csv

# Load JSON data from a file
def load_json(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)

def filter_and_print_and_save(data, target_date, output_csv):
    filtered_data = []
    
    for item in data:
        tags = [tag["tagName"] for tag in item.get("tags", [])]
        public_date = item.get("publicDisclosureAvailabilityDate", "N/A")
        
        if ("Microsoft Purview compliance portal" in tags or "Microsoft Information Protection" in tags) and public_date == target_date:
            print(f"ID: {item['id']}")
            print(f"Title: {item['title']}")
            print(f"Description: {item['description']}")
            print(f"Public Disclosure Availability Date: {public_date}")
            print("-" * 50)
            
            filtered_data.append([item['id'], item['title'], item['description'], public_date])
    
    # Save results to CSV
    if filtered_data:
        with open(output_csv, 'w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            writer.writerow(["ID", "Title", "Description", "Public Disclosure Availability Date"])
            writer.writerows(filtered_data)
            print(f"Filtered results saved to {output_csv}")

# Load JSON from file and process it
file_path = "data.json"  # Change this to the actual file path
target_date = "April CY2025"  # Modify this variable as needed
output_csv = "filtered_data.csv"  # Output CSV file

data = load_json(file_path)
filter_and_print_and_save(data, target_date, output_csv)