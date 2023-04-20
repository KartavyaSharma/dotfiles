import hashlib
import fire


def validate(password=""):
    # Get salt file
    salt = ""
    with open("salt", "r") as f:
        salt = [line for line in f.readlines()][0].strip()
    # Get compare hash
    hash = ""
    with open("enc_sudo", "r") as f:
        hash = [line for line in f.readlines()][0].strip()
    # Create salted string
    salted = str(password) + salt
    # Hash salted using hashlib
    hashed = hashlib.md5(salted.encode()).hexdigest()
    if hashed != hash:
        print(0)
    else:
        print(1)


if __name__ == "__main__":
    fire.Fire(validate)
