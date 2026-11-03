# 1.Određivanje doba dana
# Napisati Python program koji za svaki sat u toku dana (od 0 do 23) ispisuje odgovarajuće doba dana:

#    noć (od 22 do 6 časova),
#    jutro (od 6 do 12 časova),
#    popodne (od 12 do 18 časova) ili
#    veče (od 18 do 22 časa)

# Sačuvati program u fajlu doba_dana.py u lokalnom repozitorijumu naziv_po_želji, a zatim izvršiti commit i push iz VS Code-a.

for i in range(24):
    print(f"Tačno je {i}h. Koje je doba dana?")
    if i >= 6 and i < 12:
        print("Jutro")
    elif i >= 12 and i < 18:
        print("Popodne")
    elif i >= 18 and i < 22:
        print("Veče")
    else:
        print("Noć")
