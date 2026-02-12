from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import mysql.connector
import qrcode
import os

app = Flask(__name__)
# ================= SECRET KEY =================
app.secret_key = os.getenv("SECRET_KEY", "elva")

# ================= KONEKSI DATABASE =================
def get_db_connection_elva():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )

# ================== REGISTER ==================
@app.route('/register_elva', methods=['GET', 'POST'])
def register_elva():
    if request.method == 'POST':
        nama_elva = request.form['nama_elva']
        username_elva = request.form['username_elva']
        password_elva = generate_password_hash(request.form['password_elva'])
        role_elva = 'pasien'

        conn = get_db_connection_elva()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT id_user_elva FROM users_elva WHERE username_elva=%s",
            (username_elva,)
        )
        if cursor.fetchone():
            flash('Username sudah digunakan', 'danger')
            return redirect(url_for('register_elva'))

        cursor.execute("""
            INSERT INTO users_elva
            (nama_elva, username_elva, password_elva, role_elva)
            VALUES (%s,%s,%s,%s)
        """, (nama_elva, username_elva, password_elva, role_elva))

        conn.commit()
        cursor.close()
        conn.close()

        flash('Registrasi berhasil, silakan login', 'success')
        return redirect(url_for('login_elva'))

    return render_template('register_elva.html')


# ================== LOGIN ==================
@app.route('/', methods=['GET', 'POST'])
@app.route('/login_elva', methods=['GET', 'POST'])
def login_elva():
    if request.method == 'POST':
        username_elva = request.form['username_elva']
        password_elva = request.form['password_elva']

        conn = get_db_connection_elva()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT * FROM users_elva
            WHERE username_elva=%s AND role_elva='pasien'
        """, (username_elva,))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if user and check_password_hash(user['password_elva'], password_elva):
            session['user_online_elva'] = user['id_user_elva']
            session['nama_online_elva'] = user['nama_elva']
            return redirect(url_for('shop_online_elva'))

        flash('Username atau password salah', 'danger')

    return render_template('login_elva.html')


# ================== SHOP ==================
@app.route('/shop_online_elva')
def shop_online_elva():
    if 'user_online_elva' not in session:
        return redirect(url_for('login_elva'))

    search_elva = request.args.get('search_elva', '')
    kategori_elva_id = request.args.get('kategori_elva', '')

    conn = get_db_connection_elva()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT o.*, k.nama_kategori_elva
        FROM obat_elva o
        JOIN kategori_elva k ON k.id_kategori_elva=o.kategori_id_elva
        WHERE 1=1
    """
    params = []

    if search_elva:
        query += " AND o.nama_obat_elva LIKE %s"
        params.append(f"%{search_elva}%")

    if kategori_elva_id:
        query += " AND o.kategori_id_elva=%s"
        params.append(kategori_elva_id)

    cursor.execute(query, params)
    obat_elva = cursor.fetchall()

    cursor.execute("SELECT * FROM kategori_elva")
    kategori_elva = cursor.fetchall()
    cursor.execute("""
        SELECT id_transaksi_elva, no_faktur_elva, tanggal_elva, total_elva, status_elva
        FROM transaksi_elva
        WHERE id_pasien_elva=%s
        ORDER BY id_transaksi_elva DESC
    """, (session['user_online_elva'],))

    list_pesanan = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        'shop_elva.html',
        list_pesanan=list_pesanan,
        obat_elva=obat_elva,
        kategori_elva=kategori_elva
    )


# ================== ADD CART ==================
@app.route('/add_cart_elva', methods=['POST'])
def add_cart_elva():
    if 'user_online_elva' not in session:
        return redirect(url_for('login_elva'))

    id_obat_elva = request.form['id_obat_elva']
    nama_obat_elva = request.form['nama_obat_elva']
    harga_elva = int(request.form['harga_elva'])

    cart = session.get('cart_elva', [])

    for item in cart:
        if item['id_obat_elva'] == id_obat_elva:
            item['jumlah_elva'] += 1
            session['cart_elva'] = cart
            return redirect(url_for('shop_online_elva'))

    cart.append({
        'id_obat_elva': id_obat_elva,
        'nama_obat_elva': nama_obat_elva,
        'harga_elva': harga_elva,
        'jumlah_elva': 1
    })

    session['cart_elva'] = cart
    return redirect(url_for('shop_online_elva'))


# ================== CART ==================
@app.route('/cart_elva')
def cart_elva():
    if 'user_online_elva' not in session:
        return redirect(url_for('login_elva'))

    cart = session.get('cart_elva', [])
    total = sum(i['harga_elva'] * i['jumlah_elva'] for i in cart)

    return render_template(
        'cart_elva.html',
        cart_elva=cart,
        total_elva=total
    )

@app.route('/checkout_form_elva')
def checkout_form_elva():
    if 'user_online_elva' not in session:
        return redirect(url_for('login_elva'))

    cart_elva = session.get('cart_elva', [])
    if not cart_elva:
        flash('Keranjang masih kosong', 'warning')
        return redirect(url_for('shop_online_elva'))

    subtotal_elva = sum(i['harga_elva'] * i['jumlah_elva'] for i in cart_elva)
    pajak_elva = int(subtotal_elva * 0.1)

    # 🔹 KURIR DARI QUERY STRING
    kurir_raw = request.args.get('kurir_elva', '')
    ongkir_elva = 0
    kurir_elva = ''

    if kurir_raw:
        kurir_elva, ongkir_elva = kurir_raw.split('|')
        ongkir_elva = int(ongkir_elva)

    diskon_elva = 0
    if subtotal_elva >= 50000:
        diskon_elva = int(subtotal_elva * 0.1)  # 10%

    total_sementara_elva = subtotal_elva + pajak_elva + ongkir_elva - diskon_elva

    return render_template(
        'checkout_form_elva.html',
        cart_elva=cart_elva,
        subtotal_elva=subtotal_elva,
        pajak_elva=pajak_elva,
        ongkir_elva=ongkir_elva,
        total_sementara_elva=total_sementara_elva,
        kurir_elva=kurir_elva,
        diskon_elva=diskon_elva,
        nama_elva=session['nama_online_elva']
    )



# ================== CHECKOUT PROCESS ==================
@app.route('/checkout_online_elva', methods=['POST'])
def checkout_online_elva():
    if 'user_online_elva' not in session:
        return redirect(url_for('login_elva'))

    alamat_elva = request.form.get('alamat_elva', '')
    metode_bayar_elva = request.form['metode_bayar_elva']

    kurir_raw = request.form['kurir_elva']
    kurir_elva, ongkir_elva = kurir_raw.split('|')
    ongkir_elva = int(ongkir_elva)

    cart = session.get('cart_elva', [])
    if not cart:
        return redirect(url_for('shop_online_elva'))

    conn = get_db_connection_elva()
    cursor = conn.cursor()

    id_pasien_elva = session['user_online_elva']
    no_faktur_elva = f"INV-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    tanggal_elva = datetime.now()

    total_barang = sum(i['harga_elva'] * i['jumlah_elva'] for i in cart)
    grand_total = total_barang + ongkir_elva

    cursor.execute("""
        INSERT INTO transaksi_elva
        (no_faktur_elva, tanggal_elva, id_pasien_elva,
         alamat_elva, metode_bayar_elva,
         kurir_elva, ongkir_elva,
         total_elva, tipe_elva, status_elva)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,'online','diproses')
    """, (
        no_faktur_elva, tanggal_elva, id_pasien_elva,
        alamat_elva, metode_bayar_elva,
        kurir_elva, ongkir_elva,
        grand_total
    ))

    id_transaksi = cursor.lastrowid

    for item in cart:
        cursor.execute("""
            INSERT INTO transaksi_detail_elva
            (id_transaksi_elva, id_obat_elva, jumlah_elva, harga_elva, total_elva)
            VALUES (%s,%s,%s,%s,%s)
        """, (
            id_transaksi,
            item['id_obat_elva'],
            item['jumlah_elva'],
            item['harga_elva'],
            item['harga_elva'] * item['jumlah_elva']
        ))

    no_resi_elva = f"ELVA-{datetime.now().strftime('%Y%m%d')}-{id_transaksi}"
    cursor.execute("""
        INSERT INTO pengiriman_elva
        (id_transaksi_elva, kurir_elva, no_resi_elva, status_elva)
        VALUES (%s,%s,%s,'diproses')
    """, (id_transaksi, kurir_elva, no_resi_elva))

    conn.commit()
    cursor.close()
    conn.close()

    session.pop('cart_elva', None)
    flash('Pesanan berhasil dibuat', 'success')
    return redirect(url_for('shop_online_elva'))

@app.route('/pesanan/<int:id_transaksi>')
def detail_pesanan_elva(id_transaksi):
    if 'user_online_elva' not in session:
        return redirect(url_for('login_elva'))

    conn = get_db_connection_elva()
    cursor = conn.cursor(dictionary=True)

    # 🔹 DATA TRANSAKSI
    cursor.execute("""
        SELECT t.*, p.no_resi_elva
        FROM transaksi_elva t
        LEFT JOIN pengiriman_elva p
            ON p.id_transaksi_elva = t.id_transaksi_elva
        WHERE t.id_transaksi_elva=%s
          AND t.id_pasien_elva=%s
    """, (id_transaksi, session['user_online_elva']))
    transaksi = cursor.fetchone()

    if not transaksi:
        flash('Pesanan tidak ditemukan', 'danger')
        return redirect(url_for('shop_online_elva'))
        
    qr_path = None
    if transaksi['kurir_elva'].lower().replace(' ', '_') == 'ambil_sendiri':
        qr_data = transaksi['no_faktur_elva']

        qr_folder = 'static/qr_elva'
        os.makedirs(qr_folder, exist_ok=True)

        qr_path = f"{qr_folder}/{qr_data}.png"

        if not os.path.exists(qr_path):
            qr_img = qrcode.make(qr_data)
            qr_img.save(qr_path)

    # 🔹 DETAIL ITEM
    cursor.execute("""
        SELECT d.*, o.nama_obat_elva
        FROM transaksi_detail_elva d
        JOIN obat_elva o ON o.id_obat_elva=d.id_obat_elva
        WHERE d.id_transaksi_elva=%s
    """, (id_transaksi,))
    items = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        'detail_pesanan_elva.html',
        transaksi=transaksi,
        items=items,
        qr_path=qr_path    )

# ================== LOGOUT ==================
@app.route('/logout_elva')
def logout_elva():
    session.clear()
    return redirect(url_for('login_elva'))
