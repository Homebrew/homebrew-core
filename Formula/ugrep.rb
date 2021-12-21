class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.4.0.tar.gz"
  sha256 "b6404b0bc83e6e852892e705deeafbe1593faf5435baa6fb58991da6242c45e4"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "99de2d46b6d9a1827ccbe6208b9c85693859f053293adcc64c94010ee334098e"
    sha256 arm64_big_sur:  "b9ba290197af9f1c54087f4accd5db4915308f0bf7df31635810e5f0c64d2010"
    sha256 monterey:       "b2b1f5e55c6097756ffea40fcc705b1e7d038e10327bfdd78d6935125f05676a"
    sha256 big_sur:        "d74469d1e6c5d6341327f9a3690efb5971405aacbd20f034171bd961d761f474"
    sha256 catalina:       "d1e72f60e3ae349839e910ecbeaf6a56a0efc2e7ff157dcb1699c34e3be70daf"
    sha256 x86_64_linux:   "2f7eb2ffa597621f91fbe9dbd270e4b771add5fcc2592e09cef538cc655be5aa"
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
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
