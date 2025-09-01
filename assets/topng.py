import os
from PIL import Image

def convert_images_to_png(folder_path, output_folder=None):
    """
    Mengonversi semua file gambar dalam folder ke PNG.

    Args:
        folder_path (str): Path folder sumber gambar.
        output_folder (str): Path folder hasil konversi (default: folder sumber).
    """
    if output_folder is None:
        output_folder = folder_path

    # Buat folder output kalau belum ada
    os.makedirs(output_folder, exist_ok=True)

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)

        # Lewati kalau bukan file
        if not os.path.isfile(file_path):
            continue

        # Coba buka gambar
        try:
            with Image.open(file_path) as img:
                # Nama file tanpa ekstensi
                base_name = os.path.splitext(filename)[0]
                output_path = os.path.join(output_folder, base_name + ".png")

                # Konversi dan simpan sebagai PNG
                img.convert("RGBA").save(output_path, "PNG")
                print(f"Berhasil convert: {filename} -> {output_path}")
        except Exception as e:
            print(f"Gagal convert {filename}: {e}")

# --- Cara pakai ---
# Ganti path berikut dengan folder gambar kamu
folder_input = "ensiklopedia"
folder_output = "gambar_png"

convert_images_to_png(folder_input, folder_output)
