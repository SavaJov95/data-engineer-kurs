import csv

# 16. Написати функцију count_lines(path: str) -> int која враћа број непразних редова у фајлу
# Input: 'data/raw/teams.csv'
# Output: 5
def count_lines(path: str) -> int:
    with open(path, 'r') as f:
        reader = csv.reader(f)
        non_empty_rows = 0

        for row in reader:
            if len(row) > 0:
                non_empty_rows += 1
    
    return non_empty_rows
    

count_lines('data/raw/teams.csv')

# 17. Написати функцију read_column(path: str, column: str) -> list која враћа све вредности једне колоне CSV фајла
# Input: 'data/raw/teams.csv', 'city'
# Output: ['Bela Palanka', 'Niš', 'Beograd, Rakovica', 'Kraljevo']
# Ако колона не постоји, вратити празну листу []
def read_column(path: str, column: str) -> list:
    with open(path, 'r') as f:
        reader = list(csv.DictReader(f))
        teams = [row[column] for row in reader if row.get(column) is not None]
                
    return teams


read_column('data/raw/teams.csv', 'city')
read_column('data/raw/teams.csv', 'town')

# 18. Написати функцију write_key_value(path: str, data: dict, headers: list) -> None која речник уписује у CSV фајл са две колоне
# Input: 'data/processed/summary.csv', {'rows': 10, 'valid': 6}, ['metric', 'value']
# Садржај фајла након позива: 
# metric,value
# rows,10
# valid,6
def write_key_value(path: str, data: dict, headers: list) -> None:
    with open(path, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        
        for k, v in data.items():
            writer.writerow({headers[0]: k, headers[1]: v}) # ne pada mi na pamet bolje rešenje nažalost
        

write_key_value('./data/processed/summary.csv', {'rows': 10, 'valid': 6}, ['metric', 'value'])

# 19. Написати функцију get_header(path: str) -> list која враћа заглавље CSV фајла
# Користити csv.reader и next()
# Input: 'data/raw/teams.csv'
# Output: ['team', 'city', 'points']
def get_header(path: str) -> list:
    with open(path, 'r') as f:
        reader = list(csv.reader(f))

    return reader[0]


get_header('data/raw/teams.csv')

# 20. Написати функцију read_rows(path: str) -> list која враћа све редове CSV фајла без заглавља, као листу листи
# Користити csv.reader
# Input: 'data/raw/teams.csv'
# Output: [['FK Jedinstvo', 'Bela Palanka', '34'], ['FK Radnički', 'Niš', '41'],['FK Rakovica', 'Beograd, Rakovica', '28'], ['FK Sloga', 'Kraljevo', '19']]
def read_rows(path: str) -> list:
    with open(path, 'r') as file:
        reader = list(csv.reader(file))

    return reader[1:]

    
read_rows('data/raw/teams.csv')

# 21. Написати функцију total_points(path: str) -> int која враћа збир бодова свих тимова
# Користити csv.DictReader
# Input: 'data/raw/teams.csv'
# Output: 122
def total_points(path: str) -> int:
    with open(path, 'r') as file:
        reader = csv.DictReader(file)
        sum = 0

        for row in reader:
            sum += int(row['points'])
    
    return sum


total_points('data/raw/teams.csv')

# 22. Написати функцију write_rows(path: str, rows: list) -> None која листу листи уписује у CSV фајл
# Input: 'data/processed/people.csv', [['name', 'age'], ['Ana', 20], ['Marko', 22]]
# Садржај фајла након позива:
# name,age
# Ana,20
# Marko,22
def write_rows(path: str, rows: list) -> None:
    with open(path, 'w') as f:
        writer = csv.writer(f)
        writer.writerows(rows)


write_rows('data/processed/people.csv', [['name', 'age'], ['Ana', 20], ['Marko', 22]])

# 23. Написати функцију write_dicts(path: str, rows: list) -> None која листу речника уписује у CSV фајл
# Користити csv.DictWriter; заглавља су кључеви првог речника
# Input: 'data/processed/people.csv', [{'name': 'Ana', 'age': 20}, {'name':'Marko', 'age': 22}]
# Садржај фајла након позива:
# name,age
# Ana,20
# Marko,22
def write_dicts(path: str, rows: list) -> None:
    with open(path, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'age'])
        writer.writeheader()
        writer.writerows(rows)


write_dicts('data/processed/people.csv', [{'name': 'Ana', 'age': 20}, {'name':'Marko', 'age': 22}])