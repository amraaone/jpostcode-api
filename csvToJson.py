import csv
import json

def csv_to_json(csv_file, json_file):
    data = []
    with open(csv_file, 'r') as csvfile:
        csvreader = csv.DictReader(csvfile)
        for row in csvreader:
            # Remove leading and trailing whitespaces from the "pc" and "id1" column values
            row['pc'] = row['pc'].strip()
            row['id1'] = row['id1'].strip()
            
            # Convert the "pc" column value to an integer (if it's not empty)
            if row['pc']:
                row['pc'] = int(row['pc'])
            
            data.append(row)

    with open(json_file, 'w') as jsonfile:
        json.dump(data, jsonfile, indent=4)

if __name__ == "__main__":
    csv_file_path = "2023-07-22-jp-postcodes.csv"
    json_file_path = "data.json"
    csv_to_json(csv_file_path, json_file_path)
