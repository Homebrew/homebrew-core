class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.0.tgz"
  sha256 "263034edd4d1e117d4051d9a9260c74dedb0efaf4491c5152b738978b3f32748"

  bottle do
    cellar :any
    sha256 "a683e2b6a8432d2489594a4f18dfb61704fdba3dc33fb8ae54ca169cee6124ee" => :catalina
    sha256 "3d8a2f79a7d04355d6c646e3b70def1159dbef4974b5783a67af6afea2d3d2e6" => :mojave
    sha256 "9a39b3a69169a7e199ee174d7b643eb07e0a7da152508ef49606d59e13cc9f3d" => :high_sierra
    sha256 "61c6a47372b1da0735a45af1e93abe8530e22b8f469ef5c4dbed836194e6b228" => :sierra
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
