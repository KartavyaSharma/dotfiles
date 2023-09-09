import hashlib
import fire
import os


def validate(password=""):
    if type(password) != str:
        password = str(password)
    m = hashlib.sha256()
    m.update(password.encode())
    generated_hash = m.hexdigest()
    if generated_hash == os.environ["PWDHASH"]:
        return 1
    return 0


if __name__ == "__main__":
    fire.Fire(validate)
