#!/usr/bin/env python3
"""
Encrypt content for the password-protected others.html page.

Usage:
  python3 encrypt.py <content_file> [password]

Reads UTF-8 HTML from <content_file>, encrypts with AES-256-GCM using a
PBKDF2-SHA256 (200000 iterations) derived key, and prints a base64 blob to
stdout. The blob format is: salt(16) || iv(12) || ciphertext+authtag.

This must match the decryption logic in others.html exactly.
"""
import sys
import os
import base64
import getpass
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

ITERATIONS = 200_000
SALT_LEN = 16
IV_LEN = 12
KEY_LEN = 32


def encrypt(plaintext: str, password: str) -> str:
    salt = os.urandom(SALT_LEN)
    iv = os.urandom(IV_LEN)
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=KEY_LEN,
        salt=salt,
        iterations=ITERATIONS,
    )
    key = kdf.derive(password.encode("utf-8"))
    aesgcm = AESGCM(key)
    ct = aesgcm.encrypt(iv, plaintext.encode("utf-8"), None)
    blob = salt + iv + ct
    return base64.b64encode(blob).decode("ascii")


def main():
    if len(sys.argv) < 2:
        print("Usage: encrypt.py <content_file> [password]", file=sys.stderr)
        sys.exit(1)
    with open(sys.argv[1], "r", encoding="utf-8") as f:
        content = f.read()
    pwd = sys.argv[2] if len(sys.argv) > 2 else getpass.getpass("Password: ")
    print(encrypt(content, pwd))


if __name__ == "__main__":
    main()
