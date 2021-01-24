class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.4.tar.gz"
  sha256 "3de80f56e82ac21fda574334a1e55d3a9027c156d4b1ce1b0e96ea99b25cda32"
  license "BSD-3-Clause"

  bottle do
    sha256 "bce1939abcb5a606c375000447cf685a6e439a267cb9e88c428507f97b0b8bb9" => :big_sur
    sha256 "831580602bc1e8d0abf5107d99364e09d089eede87026fc4366fb6fda2bc6b04" => :arm64_big_sur
    sha256 "018124dbd077c90bf42b8b3822d2a4cd8be799730a069022ffd2841913771b30" => :catalina
    sha256 "a56844b0fbf89467ba41274c59c8e7da3443795204440656fa0bc9c141d08aad" => :mojave
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
