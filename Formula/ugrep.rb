class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.3.tar.gz"
  sha256 "6416e06d1358316aafa147aa74e5bc7d05502f1d78d742248b3fdce0f6fbeae1"
  license "BSD-3-Clause"

  bottle do
    sha256 "7070dcf6482d7d8ca1e7623e6d6c2caca9272a32a6b32cc1c9d5d2533b04b8b6" => :big_sur
    sha256 "1a2a4ea5dc79587a3cc4cba0321e55f142b28d8a1e57e000cbe10e75d828ef93" => :arm64_big_sur
    sha256 "5028518652d9a6c42b27e90bc2b1e05b70c4eb7089abc025e2df71c7a1ff5440" => :catalina
    sha256 "3fc22f39ae49ed83c1845dd5138d0c63e321109dcd148b3abac6539b129023ea" => :mojave
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match /Hello World!/, shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match /Hello World!/, shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
