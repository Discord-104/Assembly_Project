# 🔐 Caesar Cipher in Assembly

This project implements a fully functional **Caesar Cipher** (both encryption and decryption) using **x86 Assembly**.
The program lets the user choose whether to encrypt or decrypt a string, select a shift key, and enter a custom message containing only valid characters from a predefined alphabet.
Everything is written using **DOS interrupts (int 21h)** for educational purposes.

---

## 📝 Overview

The program performs these main tasks:

1. Asks the user whether they want to **encrypt (c)** or **decrypt (d)**.
2. Requests a **key value** (shift amount), ensuring it is valid.
3. Builds an internal **shifted alphabet (cipher alphabet)** based on the given key.
4. Accepts a string from the user and checks that all characters belong to the supported alphabet.
5. Applies encryption or decryption depending on the user's choice.
6. Prints the final result.

---

## 🔧 Features

### ✔️ Mode Selection

Users can choose between:

* **c** → Encrypt a string
* **d** → Decrypt a string

### ✔️ Input Validation

The program checks:

* That the key is **greater than 1**
* That the key is **less than the alphabet length**
* That each inserted character exists in the supported alphabet
* That the input string has a maximum limit of **100 characters**

### ✔️ Custom Alphabet

The cipher uses a manually defined alphabet containing:

* Special characters
* Numbers
* Uppercase letters
* Lowercase letters

### ✔️ Caesar Cipher Logic

* The alphabet is shifted by *n* positions (n = key)
* Encryption maps **original alphabet → shifted alphabet**
* Decryption maps **shifted alphabet → original alphabet**

### ✔️ Clean Modular Code

The program uses several procedures:

* `Richiesta` – Mode selection
* `InputChiave` – Key input
* `CreaCifrario` – Build shifted alphabet
* `InputStringa` – Read and validate string
* `Cifratura` – Encrypt
* `Decifratura` – Decrypt

---

## 🚀 How to Run

1. Assemble the program using **MASM**, **TASM**, or another x86 assembler
2. Link the object file to generate an executable
3. Run the program in a DOS environment (recommended: **DOSBox**)

Example:

```
tasm cifrario.asm
tlink cifrario.obj
dosbox cifrario.exe
```

---

## 💡 Example Usage

```
Do you want to encrypt (c) or decrypt (d)?
c
Enter the key:
4
Enter a string:
HELLO
Encrypted String:
LIPPS
```

```
Do you want to encrypt (c) or decrypt (d)?
d
Enter the key:
4
Enter a string:
LIPPS
Decrypted String:
HELLO
```

---

## 🧠 Technologies Used

* **x86 Assembly**
* **DOS interrupts (int 21h)** for:

  * Input handling
  * Output printing
  * Program termination
* **Modular procedures** for readability and structure

---

## 📚 License

This project is open for **educational use**, experimentation, and modifications.
Feel free to expand it, rewrite parts, or integrate new features!

---

## 👨‍💻 Author

Created by **OraOtak**
