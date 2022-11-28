class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.1.tgz"
  sha256 "df2f23197c9589963267f85f9c5307ecf2b35a98b83a551bf1b1fb7a4d06d4c2"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "cae01628c68cb6961a9515a9b6815dc390bce773d69da24b2e92dce4c45db8cb"
    sha256 cellar: :any,                 arm64_monterey: "d76d3d327a97c51b522d65f6c6fc1dbcd227fccc39f0de4cde9ab991f138d9a9"
    sha256 cellar: :any,                 arm64_big_sur:  "358e1343aa3e64b5b94a5eddfd5e75da9c9d089a18784f0fa21db93f9f34af2f"
    sha256 cellar: :any,                 ventura:        "7810b10c20fb90123866aefb62360604e65166a5fb21e5148ffda194b44ba49f"
    sha256 cellar: :any,                 monterey:       "86671c984e05a532e7b25c9f8c6712096592a15147a04948ca80d9006335ba8d"
    sha256 cellar: :any,                 big_sur:        "98864356e7d2a46eae0d85de33445b3baacf7d2bc362f34cebcc89c959e33b61"
    sha256 cellar: :any,                 catalina:       "34668a3ffd312cd9687a9b9c4fef5e0ccf36103a9dca92cb2cd6c640aa87c9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a301fa271721417d2aaa18c941716b1d64d22fafef03c3f91bf4aea0d072cf12"
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git"

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
