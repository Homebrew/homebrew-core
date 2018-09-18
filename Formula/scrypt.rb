class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.2.1.tgz"
  sha256 "4621f5e7da2f802e20850436219370092e9fcda93bd598f6d4236cce33f4c577"

  bottle do
    cellar :any
    sha256 "dbe434d01b09f02e1cc7fee6e163acd87d70270aecc355907fbf99dbc98fd59c" => :mojave
    sha256 "fa929a235e8b07184fd77a35fb38d0ce08e4d627130057144ba40873b355702d" => :high_sierra
    sha256 "d2f0f0170d78fae63833094fbdcb920489c9e04fb4579a0b82ca527ebd7bb12f" => :sierra
    sha256 "2028c6a6a14d6753deae95d35d94c75cfcc64633ed69b3fea7f9da7a47d079b1" => :el_capitan
    sha256 "15c52d5c143e002bd5dec4bb70020f0ff05f66a85067e187e1a08b0d04f3b9f5" => :yosemite
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"

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
