# 1. Sistem beleži broj aktivnih korisnika tokom 12 uzastopnih sati.
# Potrebno je:
# 1) Prikazati broj korisnika za peti sat.
# 2) Prikazati broj korisnika za poslednja četiri sata.
# 3) Izračunati ukupan broj aktivnih korisnika kroz svih 12 sati.
# 4) Izračunati prosečan broj korisnika po satu.
# 5) Pronaći sat sa najvećim brojem korisnika.
import numpy as np

active_users = np.array([1200, 960, 840, 1250, 1500, 1710, 1430, 2060, 1580, 1330, 1720, 1190])

# 1)
print(active_users[4])
# 2)
print(active_users[-4:])
# 3)
print(np.sum(active_users))
# 4)
print(np.mean(active_users))
# 5)
print(np.max(active_users))



# 2. Sistem beleži CPU, RAM i disk usage za pet različitih servera.
# Redovi predstavljaju servere, a kolone CPU, RAM i disk usage.
# Potrebno je:
# 1) Prikazati dimenzije matrice.
# 2) Prikazati broj servera i broj metrika.
# 3) Izračunati prosečnu vrednost svake metrike.
# 4) Izračunati prosečnu potrošnju resursa za svaki server.
# 5) Pronaći server sa najvećom prosečnom potrošnjom resursa.
usage_and_servers = np.array([[55, 82, 60], [62, 80, 65], [57, 91, 70], [48, 73, 58], [84, 77, 91]])

# 1)
print(usage_and_servers.ndim)
# 2)
print(usage_and_servers.size)
# 3)
print(np.mean(usage_and_servers, axis=0))
# 4)
print(np.mean(usage_and_servers, axis=1))
# 5)
print(np.max(np.mean(usage_and_servers, axis=1)))



# 3. Sistem beleži vreme izvršavanja 15 različitih procesa u
# sekundama. Potrebno je:
# 1) Pronaći sve procese koji su trajali duže od 100 sekundi.
# 2) Pronaći procese koji su trajali između 40 i 100 sekundi.
# 3) Izbrojati procese koji su trajali kraće od 50 sekundi.
# 4) Pronaći indekse procesa koji su trajali duže od 100 sekundi.
# 5) Izračunati prosečno vreme izvršavanja svih procesa.
process_exec_time = np.array([91, 30, 45, 67, 82, 11, 10, 87, 74, 119, 129, 134, 83, 65, 143])

# 1)
print(process_exec_time[process_exec_time > 100])
# 2)
print(process_exec_time[(process_exec_time >= 40) & (process_exec_time <= 100)])
# 3)
print(process_exec_time[process_exec_time < 50])
# 4)
print(np.where(process_exec_time > 100))
# 5)
print(np.mean(process_exec_time))



# 4. Prodavnica beleži prihode od četiri različite kategorije proizvoda
# tokom šest meseci. Redovi predstavljaju kategorije proizvoda, a
# kolone mesece. Potrebno je:
# 1. Izračunati ukupan prihod svake kategorije proizvoda.
# 2. Izračunati ukupan prihod za svaki mesec.
# 3. Pronaći kategoriju proizvoda sa najvećim ukupnim prihodom.
# 4. Pronaći mesec sa najvećim ukupnim prihodom.
# 5. Izračunati prosečan prihod po kategoriji proizvoda.
# 6. Izračunati prosečan mesečni prihod svih kategorija.
rng = np.random.default_rng()
categories_months = rng.integers(low=100, high=250, size=(4, 6))

# 1.
print(np.sum(categories_months, axis=1))
# 2.
print(np.sum(categories_months, axis=0))
# 3.
print(np.max(np.sum(categories_months, axis=1)))
# 4.
print(np.max(np.sum(categories_months, axis=0)))
# 5.
print(np.mean(categories_months, axis=1))
# 6.
print(np.mean(categories_months, axis=0))



# 5. Sistem beleži prosečne dnevne temperature tokom 15 dana. Neki
# podaci nedostaju ili nisu validni.
# Validna temperatura mora biti između -20 i 50 stepeni.
# Potrebno je:
# 1) Identifikovati nedostajuće vrednosti.
# 2) Identifikovati nevalidne temperature (vrednosti manje od -20 ili veće od 50).
# 3) Pronaći indekse nevalidnih vrednosti.
# 4) Izračunati broj nedostajućih i nevalidnih vrednosti.
# 5) Izračunati procenat nevalidnih i nedostajućih zapisa zajedno.
# 6) Kreirati novi niz koji sadrži samo validne temperature.
# 7) Izračunati prosečnu temperaturu bez nedostajućih i nevalidnih vrednosti.
temperatures = rng.integers(low=-30, high=60, size=(15)).astype(float)
temperatures[8] = np.nan

# 1)
nan_values = temperatures[np.isnan(temperatures)]
print(nan_values)
# 2)
invalid_values = temperatures[(temperatures < -20) | (temperatures > 50)]
print(invalid_values)
# 3)
print(np.where((temperatures < -20) | (temperatures > 50)))
# 4)
print(len(nan_values) + len(invalid_values))
# 5)
print((len(nan_values) + len(invalid_values)) / len(temperatures) * 100)
# 6)
valid_temperatures = rng.integers(low=-20, high=50, size=(15)).astype(float)
# 7)
print(np.nanmean(temperatures[(temperatures >= -20) & (temperatures <= 50)])) #ako se trazi od prvobitnog
print(np.mean(valid_temperatures))