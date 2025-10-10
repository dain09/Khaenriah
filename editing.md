#How To Editing the Game List with Vi



# A Practical Guide to Editing the Game List with Vi



Welcome! You've encountered the `Vi` editor. It's one of the most powerful and classic text editors, but it can be confusing for new users because it operates differently from modern editors like Notepad or Nano.



Think of it like driving a manual car: you have to be in the right "mode" to do what you want. This guide will make it simple.



---



## The Two Modes of Vi (The Most Important Concept)



`Vi` has two primary modes. Understanding them is the key to everything.



### 1. Command Mode

- **What it is:** The default mode you are in when you first open a file.

- **What you can do:** Move the cursor, delete lines, copy/paste, and enter commands (like saving or quitting).

- **What you CANNOT do:** You cannot type text directly into the file.

- **Think of it as:** The **Control Panel** for the file.



> **To return to Command Mode at any time, press the `Esc` key.** If you're ever lost, just press `Esc` a couple of times.



### 2. Insert Mode

- **What it is:** The mode for writing and editing text.

- **What you can do:** Type letters, numbers, and symbols directly into the file, just like in any normal editor.

- **How to enter:** Press the `i` key while in Command Mode.

- **Think of it as:** **Typing Mode**.



---



## Step-by-Step: Editing and Saving the Game List



Let's walk through the exact process of adding a new game to your list.



### Step 1: Navigate to the Right Place

- **Your current mode:** You start in **Command Mode**.

- **Action:** Use the **arrow keys** on your keyboard to move the cursor.

- **Goal:** Move the cursor to the end of the last line, or to a new line where you want to add the game's package name.



### Step 2: Enter Insert Mode to Start Typing

- **Your current mode:** **Command Mode**.

- **Action:** Press the `i` key once.

- **What you'll see:** A label like `-- INSERT --` will appear at the bottom of the screen. This confirms you are now in **Insert Mode**.



### Step 3: Add or Edit Your Game List

- **Your current mode:** **Insert Mode**.

- **Action:** You can now type freely.

 - Add the package name for your new game (e.g., `com.my.new.game`).

 - Press `Enter` to create a new line for another game.

 - Use `Backspace` to correct any typos.



### Step 4: Exit Insert Mode (Crucial Step!)

- **Your current mode:** **Insert Mode**.

- **Action:** When you have finished all your edits, press the `Esc` key once.

- **What you'll see:** The `-- INSERT --` label will disappear. You are now safely back in **Command Mode**.



### Step 5: Save Your Changes and Quit

- **Your current mode:** **Command Mode**.

- **Action:** Type the following command exactly:

 ```

 :wq

 ```

 - The colon (`:`) tells `Vi` you are about to enter a command.

 - `w` stands for **w**rite (save the file).

 - `q` stands for **q**uit (exit the editor).

- **Final Action:** Press `Enter`.



The editor will now close, your changes will be saved, and you will return to the Khaenriah script menu.



---



## The "I Made a Mistake!" Escape Hatch



What if you made changes you don't want to keep? It's easy to exit without saving.



1. **Get to Command Mode:** Press `Esc` to make sure you are not in Insert Mode.

2. **Enter the "Quit Without Saving" Command:** Type the following:

  ```

  :q!

  ```

  - The exclamation mark (`!`) means "Force the action!" In this case, it forces the editor to quit and discard any unsaved changes.

3. **Press `Enter`.** You will exit immediately, and the file will remain untouched.



---



## Quick Reference (Cheat Sheet)



| Action          | Key / Command | Mode       |

| ------------------------ | ------------- | ----------------- |

| **Enter Typing Mode**  | `i`      | From Command Mode |

| **Return to Command Mode** | `Esc`     | From Insert Mode |

| **Save & Exit**     | `:wq` + `Enter` | In Command Mode  |

| **Exit Without Saving** | `:q!` + `Enter` | In Command Mode  |
