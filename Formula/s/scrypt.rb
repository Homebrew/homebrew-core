class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.2.tgz"
  sha256 "d632c1193420ac6faebf9482e65e33d3a5664eccd643b09a509d21d1c1f29be2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0d7e64dd207cba97c39704e864ad290bd1acf4a06f002d551d0ce61a6595e275"
    sha256 cellar: :any,                 arm64_sonoma:   "bcaf79c22f7e771cc3de6daf16bc780cd096d64c0e58a0bb3f566847e26d27ca"
    sha256 cellar: :any,                 arm64_ventura:  "c8a4497efd6560ce5f4863ddddee72f26bd40093518d2a689c84dfb55b5b07b9"
    sha256 cellar: :any,                 arm64_monterey: "d5aaaeead2e355122d8627e5eced65f890c711ab53e0e0c12ad4a2430c485b87"
    sha256 cellar: :any,                 sonoma:         "5b89c96efd423b5d9db1f4f02257e170db5d5c1aa176799c4c8e7fa636248be4"
    sha256 cellar: :any,                 ventura:        "1f6aecb338fd4c428186119c5d164f1900d67e6d5cdb939683c7a87bea6930fc"
    sha256 cellar: :any,                 monterey:       "675517b089005b5693f13719ab5fefd91ee18e10cda8f4a06ce6b9ea3ab3e3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8663d530d116f3197993aff60d0cd23aed96eeb49ff86d317fa7d58d4961d74"
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

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
