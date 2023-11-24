# consume_memory.py
import os
import psutil
import time

def consume_memory():
    available_memory = psutil.virtual_memory().available

    try:
        memory_block = bytearray(available_memory)
        while True:
            # Keep the allocated memory occupied
            memory_block[0] = 0
            time.sleep(1)
    except KeyboardInterrupt:
        print("Memory consumption stopped.")

if __name__ == "__main__":
    consume_memory()
