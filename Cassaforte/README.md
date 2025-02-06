# 🔐 Assembly Code Project - Secure Vault 🏦

This project simulates a **secure vault** with a simple code entry system written in Assembly. The vault can be opened with a specific code, and it checks several conditions before granting access. If the code is incorrect, it triggers a self-destruct countdown! 💥

## 📝 Overview

This program simulates a safe that requires a code to open. The code needs to pass four checks:

1. The code must consist of 10 digits (0-9).
2. The digits must alternate between even and odd numbers.
3. The code cannot have the digit '9' immediately after '4'.
4. The code cannot start with the digit '0'.

If the code passes all checks, the vault opens! Otherwise, a self-destruct countdown is triggered. ⏳

## 🔧 Features

- **Input validation:** Ensures that the code meets the required conditions.
- **Multiple attempts:** You can try entering the code multiple times.
- **Self-destruction countdown:** If the code is incorrect after the second attempt, the program activates a countdown before self-destructing. 💥
- **Assembly language:** Written in Assembly for educational purposes.

## 📥 Usage

1. **Run the Program:**
   - The program will prompt you to enter a 10-digit code.
   - If the code is valid, the vault will open! 🔓
   - If the code is invalid, you can try again.
   - After two incorrect attempts, the self-destruct countdown will begin! ⏰

2. **Code Checks:**
   - **Check 1:** Code must be 10 digits (0-9).
   - **Check 2:** Even and odd digits must alternate.
   - **Check 3:** The digit '9' cannot follow '4'.
   - **Check 4:** The code cannot start with '0'.

3. **Special Messages:**
   - If the vault opens: "Vault unlocked! 🔓"
   - If self-destruction occurs: "Self-destruction in 3... 2... 1... 💥"

## ⚙️ How to Run

1. Assemble the code using an assembler like **MASM** or **TASM**.
2. Link the object file to create an executable.
3. Run the executable in a DOS environment or emulator like **DOSBox**.

## 🤖 Technologies Used

- **Assembly Language:** For simulating the logic of code verification and vault operations.
- **DOS Interrupts (int 21h):** Used for input and output handling.

## 📚 License

This project is for educational purposes and can be freely used and modified. 💻

## 👨‍💻 Author

Created by **OraOtak** 💡

---

Feel free to contribute to this project! ✨ If you find any issues or bugs, please open an issue, and I'll work on fixing it. 😊
