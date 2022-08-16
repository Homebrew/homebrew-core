class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.1.tar.gz"
  sha256 "7e016a3fddb2f17534ca4b2a5119120f7791f0dee96f9f320b7ea37ecc4f1956"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "7f705be605d991c56b9d982572f767ae35a6a4487a416351bfcfbbe7295a143f"
    sha256 arm64_big_sur:  "42d72a453b67f5ac800b123e8c23aae3aa05d531d14c3f9b9edfcd380eac89b2"
    sha256 monterey:       "4e0e1299f122eb7ca025adf06cb5a3c0203ba31e9fd63715e1add1265bd565aa"
    sha256 big_sur:        "6a7545a0e6dafcb0e813ae7e4cd054d408287d6950c40f12abfabc6a684c9d5c"
    sha256 catalina:       "39b2a993587fa3a84178c3edf5eadb74ccae965a6ee255bd65bfb40892126477"
    sha256 x86_64_linux:   "942b50d9d75627e49e1fd93efd32512cc2519bb08df598fa253f328486bebd04"
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
