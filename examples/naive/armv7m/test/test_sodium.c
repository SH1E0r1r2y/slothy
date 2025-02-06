#include <stdio.h>
#include <sodium.h>

int main() {
    // 初始化 libsodium
    if (sodium_init() < 0) {
        printf("libsodium initialization failed\n");
        return 1;
    }

    // 創建一對隨機密鑰
    unsigned char key[crypto_secretbox_KEYBYTES];
    unsigned char nonce[crypto_secretbox_NONCEBYTES];
    unsigned char message[] = "Hello, world!";
    unsigned char ciphertext[sizeof(message)];

    // 生成隨機密鑰和nonce
    randombytes_buf(key, sizeof(key));
    randombytes_buf(nonce, sizeof(nonce));

    // 加密訊息
    crypto_secretbox_easy(ciphertext, message, sizeof(message), nonce, key);

    printf("Encrypted message: ");
    for (size_t i = 0; i < sizeof(ciphertext); i++) {
        printf("%02x", ciphertext[i]);
    }
    printf("\n");

    return 0;
}
