import json
import random

# Temel kalıplar ve örnekler
basic_patterns = [
    {
        "english": "How are you?",
        "turkish": "Nasılsın?",
        "example": "How are you today? - Bugün nasılsın?"
    },
    {
        "english": "What's up?",
        "turkish": "Ne haber?",
        "example": "Hey, what's up? - Hey, ne haber?"
    },
    {
        "english": "I'm fine, thanks.",
        "turkish": "İyiyim, teşekkürler.",
        "example": "How are you? I'm fine, thanks. - Nasılsın? İyiyim, teşekkürler."
    },
    {
        "english": "Nice to meet you.",
        "turkish": "Tanıştığımıza memnun oldum.",
        "example": "Hi, I'm John. Nice to meet you. - Merhaba, ben John. Tanıştığımıza memnun oldum."
    },
    {
        "english": "See you later.",
        "turkish": "Görüşürüz.",
        "example": "I have to go now. See you later. - Şimdi gitmem lazım. Görüşürüz."
    }
]

# Günlük konuşma kalıpları
daily_patterns = [
    {
        "english": "What's your name?",
        "turkish": "Adın ne?",
        "example": "Hi, what's your name? - Merhaba, adın ne?"
    },
    {
        "english": "My name is...",
        "turkish": "Benim adım...",
        "example": "My name is Sarah. - Benim adım Sarah."
    },
    {
        "english": "Where are you from?",
        "turkish": "Nerelisin?",
        "example": "Where are you from? I'm from Turkey. - Nerelisin? Ben Türkiye'denim."
    },
    {
        "english": "I'm from...",
        "turkish": "Ben ...'denim",
        "example": "I'm from Istanbul. - Ben İstanbul'danım."
    },
    {
        "english": "How old are you?",
        "turkish": "Kaç yaşındasın?",
        "example": "How old are you? I'm 25 years old. - Kaç yaşındasın? 25 yaşındayım."
    }
]

# İş kalıpları
business_patterns = [
    {
        "english": "Could you please...",
        "turkish": "Lütfen ... yapar mısınız?",
        "example": "Could you please send me the report? - Lütfen bana raporu gönderir misiniz?"
    },
    {
        "english": "I would like to...",
        "turkish": "... istiyorum",
        "example": "I would like to schedule a meeting. - Bir toplantı planlamak istiyorum."
    },
    {
        "english": "Thank you for...",
        "turkish": "... için teşekkür ederim",
        "example": "Thank you for your help. - Yardımınız için teşekkür ederim."
    }
]

# Seyahat kalıpları
travel_patterns = [
    {
        "english": "Where is...?",
        "turkish": "... nerede?",
        "example": "Where is the nearest hotel? - En yakın otel nerede?"
    },
    {
        "english": "How can I get to...?",
        "turkish": "...'a nasıl gidebilirim?",
        "example": "How can I get to the airport? - Havalimanına nasıl gidebilirim?"
    },
    {
        "english": "I need...",
        "turkish": "... ihtiyacım var",
        "example": "I need a taxi. - Bir taksiye ihtiyacım var."
    }
]

# Tüm kalıpları birleştir
all_patterns = basic_patterns + daily_patterns + business_patterns + travel_patterns

# 1200 chunk oluştur
chunks = []
for i in range(1200):
    # Mevcut kalıplardan birini seç
    base_pattern = random.choice(all_patterns)
    
    # Kalıbı kopyala ve varyasyonlar ekle
    chunk = base_pattern.copy()
    
    # Rastgele varyasyonlar ekle
    if random.random() < 0.3:  # %30 ihtimalle varyasyon ekle
        chunk['english'] = f"{chunk['english']} {random.choice(['please', 'thank you', 'excuse me'])}"
        chunk['turkish'] = f"{chunk['turkish']} {random.choice(['lütfen', 'teşekkürler', 'özür dilerim'])}"
    
    chunks.append(chunk)

# JSON dosyasına kaydet
with open('../assets/chunks.json', 'w', encoding='utf-8') as f:
    json.dump({'chunks': chunks}, f, ensure_ascii=False, indent=2)

print(f"Generated {len(chunks)} chunks successfully!") 