
import tkinter as tk
from tkinter import messagebox
import subprocess
import os

def run_optimizer():
    try:
        script_path = "WindowsOptimizer.ps1"
        if not os.path.exists(script_path):
            raise FileNotFoundError(f"Скрипт не найден: {script_path}")
        
        subprocess.run(["powershell.exe", "-Command", f".\\{script_path}"], check=True)
        messagebox.showinfo("Готово!", "Оптимизация завершена!")
    except Exception as e:
        error_msg = str(e)
        if "Access is denied" in error_msg or "ExecutionPolicy" in error_msg:
            messagebox.showerror("Ошибка", "Запустите скрипт от имени администратора.")
        else:
            messagebox.showerror("Ошибка", f"Не удалось запустить скрипт: {error_msg}")

root = tk.Tk()
root.title("WindowsOptimizer")
root.geometry("300x200")
root.resizable(False, False)

label = tk.Label(root, text="Оптимизация Windows", font=("Arial", 14))
label.pack(pady=20)

button = tk.Button(root, text="Запустить оптимизацию", command=run_optimizer, bg="green", fg="white", font=("Arial", 12), padx=10, pady=5)
button.pack(pady=10)

info_label = tk.Label(root, text="⚠️ Запускайте от имени администратора", fg="red", font=("Arial", 9))
info_label.pack(pady=5)

root.mainloop()
