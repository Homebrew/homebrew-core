class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.0.tgz"
  sha256 "263034edd4d1e117d4051d9a9260c74dedb0efaf4491c5152b738978b3f32748"

  bottle do
    cellar :any
    sha256 "6e4b8113c28d5f49e1b0b3b42c5db49228157ae7554fd9564a73c8015e96b62c" => :mojave
    sha256 "e1fb4bd2c12f70cd0d1427d42a9696744529d26bf5db5b1c2151f039e529075c" => :high_sierra
    sha256 "f07e1a167f4c789fc0cd159d2bc48d4394b9d14c7ce870cc10fd706dfef68c57" => :sierra
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/scrypt enc homebrew.txt homebrew.txt.enc
      expect -exact "Please enter passphrase: "
      send -- "Testing\n"
      expect -exact "\r
      Please confirm passphrase: "
      send -- "Testing\n"
      expect eof
    EOS
    chmod 0755, testpath/"test.sh"
    touch "homebrew.txt"

    system "./test.sh"
    assert_predicate testpath/"homebrew.txt.enc", :exist?
  end
end
