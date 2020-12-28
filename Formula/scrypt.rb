class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.1.tgz"
  sha256 "df2f23197c9589963267f85f9c5307ecf2b35a98b83a551bf1b1fb7a4d06d4c2"
  license "BSD-2-Clause"

  head do
    url "https://github.com/Tarsnap/scrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    cellar :any
    sha256 "1f89391f94ab6214697175294471c13003f638d7ca9ca57924f32a7aff223078" => :big_sur
    sha256 "452d9a1d1ebf709a71aebf1814646bf1fff3858d1ec9d4e1fd9ee802b93dd9e3" => :arm64_big_sur
    sha256 "8f28f665fb701809fafc7f001d391c0139dd3f779317b0f2b82090577d189754" => :catalina
    sha256 "45a1cf76ba4ebb0708e3d751001e718f28bdbf659a020553742a17a688a91944" => :mojave
    sha256 "9c98acfbc8fc0def4b78d8f1101c236a15986ded5fabee93d1530ef17096817a" => :high_sierra
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
