class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.1.tgz"
  sha256 "df2f23197c9589963267f85f9c5307ecf2b35a98b83a551bf1b1fb7a4d06d4c2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a451784bb5c8dfcbbac4e6d25a85f0986006e8580a831a8d2db4b1c8bf6facae"
    sha256 cellar: :any,                 arm64_big_sur:  "452d9a1d1ebf709a71aebf1814646bf1fff3858d1ec9d4e1fd9ee802b93dd9e3"
    sha256 cellar: :any,                 monterey:       "eda3c8c8096fc9756b3d6b8b55ee414b2afcfc9b349717d4939c89bc900b40bf"
    sha256 cellar: :any,                 big_sur:        "1f89391f94ab6214697175294471c13003f638d7ca9ca57924f32a7aff223078"
    sha256 cellar: :any,                 catalina:       "8f28f665fb701809fafc7f001d391c0139dd3f779317b0f2b82090577d189754"
    sha256 cellar: :any,                 mojave:         "45a1cf76ba4ebb0708e3d751001e718f28bdbf659a020553742a17a688a91944"
    sha256 cellar: :any,                 high_sierra:    "9c98acfbc8fc0def4b78d8f1101c236a15986ded5fabee93d1530ef17096817a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ecda30c356a01e3e084cb93bc0b791e8f6d8333bbcc0ad7b16a9d9b85c6d8a"
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "expect" => :test

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/scrypt enc homebrew.txt homebrew.txt.enc
      expect -exact "Please enter passphrase: "
      send -- "Testing\n"
      expect -exact "\r
      Please confirm passphrase: "
      send -- "Testing\n"
      expect eof
    EOS
    touch "homebrew.txt"

    system "expect", "-f", "test.exp"
    assert_predicate testpath/"homebrew.txt.enc", :exist?
  end
end
