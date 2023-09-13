import random
import string
import time

def generate_random_string(length):
    letters = string.ascii_letters
    return ''.join(random.choice(letters) for _ in range(length))

random_reasons = [
    'Invalid file',
    'Stack overflow',
    'Worked on my machine',
    'work in progress',
    'Not enough CPU',
    'Not enough GPU',
    'Not enough RAM',
    'Not enough ROM',
]

error_messages = []
for i in [400, 403, 404, 500]:
    error_messages.append('Error ' + str(i))

error_count = 0
with open('files/ApplicationData/output/logs/messages.txt', 'w') as f:
    for i in range(100):
        if i % 2 == 0:
            f.write(f'{error_messages[error_count % len(error_messages)]} {random_reasons[error_count % len(random_reasons)]}\n')
            f.write(f'{error_messages[error_count % len(error_messages)]} {random_reasons[error_count % len(random_reasons)]}\n')
            error_count += 1
        f.write(generate_random_string(50) + '\n')

def str_time_prop(start, end, time_format, prop):
    stime = time.mktime(time.strptime(start, time_format))
    etime = time.mktime(time.strptime(end, time_format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(time_format, time.localtime(ptime)).replace(' ', '-')


def random_date(start, end, prop):
    return str_time_prop(start, end, '%m/%d/%Y %I:%M %p', prop)

with open('files/ApplicationData/db.tsv', 'w') as f:
    f.write('id\tdate\tname\ttype\tsize\n')
    for i in range(100):
        f.write(f'{i}\t{random_date("1/1/2000 1:30 PM", "1/1/2012 4:50 PM", random.random())}\t{generate_random_string(10)}\t{random.choice(error_messages).replace(" ", "-")}\t{random.randint(0, 2 ** 12)}\n')

for i in range(10):
    with open(f'files/Documents/file{i}.txt', 'w') as f:
        for j in range(random.randint(1, 100)):
            f.write(generate_random_string(50) + '\n')

for i in range(10):
    with open(f'files/Documents/Downloads/download{i}.bin', 'wb') as f:
        for j in range(random.randint(1, 256)):
            f.write(str.encode(generate_random_string(50)))

for i in range(10):
    with open(f'files/Documents/Desktop/{i}.ico', 'wb') as f:
        for j in range(random.randint(1, 10)):
            f.write(str.encode(generate_random_string(10)))

