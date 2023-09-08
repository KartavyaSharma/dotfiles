import hashlib
import fire
import os


def validate(password=""):
    # Get salt file
    salt = ""
    with open(os.path.dirname(__file__) + "/salt", "r") as f:
        salt = [line for line in f.readlines()][0].strip()
    # Get compare hash
    hash = ""
    with open(os.path.dirname(__file__) + "/enc_sudo", "r") as f:
        hash = [line for line in f.readlines()][0].strip()
    # Create salted string
    salted = str(password) + salt
    # Hash salted using hashlib
    hashed = hashlib.md5(salted.encode()).hexdigest()
    if hashed == hash:
        return 1
    return 0


if __name__ == "__main__":
    fire.Fire(validate)
