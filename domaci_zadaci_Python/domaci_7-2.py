# 1. Napisati program kojim se prevodi temperatura iz Celzijusove skale u Farenhajtovu skalu,
# ako je odgovarajuca formula oblika T[F] = T[C] * 1.80 + 32. Na ulazu se unosi vrednost
# temperature u stepenima Celzijusa (realan broj) a ispisuje se vrednost temperature u stepenima
# Farenhajta.

def calc_F_temp(celsius):
    return celsius * 1.80 + 32

print(calc_F_temp(20))


# 2. Napisati program koji za uneti redni broj dana u nedelji (od 1 do 7) ispisuje naziv tog
# dana (ponedeljak - nedelja). Ukoliko je unet broj koji nije izmedju 1 i 7, ispisati Pogresan
# unos.

day_names = ("ponedeljak", "utorak", "sreda", "cetvrtak", "petak", "subota", "nedelja")

def print_day_name(day_num):
    if day_num < 1 or day_num > 7:
        print("Pogresan unos")
    else:
        print(day_names[day_num - 1])

print_day_name(7)
print_day_name(8)


# 3. Napisati program koji racuna najveci negativni element u listi.

numbers = [-2, -20, 3, 56, -80, 100, -150, -1]

def find_max_negative_value(nums):
    max_negative = None
    for n in nums:
        if n < 0 and (max_negative is None or n > max_negative):
            max_negative = n
    return max_negative

print(find_max_negative_value(numbers))


# 5. Napisati program koji racuna broj parnih elemenata date liste.

num_list = [1, 3, 4, 7, 8, 12]

def find_even_numbers(nums):
    evens = 0
    for n in nums:
        if n % 2 == 0:
            evens += 1
    return evens

print(find_even_numbers(num_list))


# 6. Napisati program koji racuna sume elemenata liste celih brojeva koji su deljivi sa 2 odnosno sa 3.

num_list2 = [1, 3, 4, 7, 8, 12, 15]

def sum_even_numbers(nums):
    num_sum = 0
    for num in nums:
        if num % 2 == 0 or num % 3 == 0:
            num_sum += num
    return num_sum

print(sum_even_numbers(num_list2))
