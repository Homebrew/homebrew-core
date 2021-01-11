class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.2.tar.gz"
  sha256 "81de520a6db437455e8ae9ee4abbdc9dc875328a359b8620ef296bb8d8364310"
  license "BSD-3-Clause"

  bottle do
    sha256 "334413432ed8d878f7506d6f027aaea776cdcc7d3b2990715369cbad103d78a7" => :big_sur
    sha256 "f0c095095e0c2b75f9bd655e72cd664990fce4561e0aa877ebddfc0a96bd9c68" => :arm64_big_sur
    sha256 "3488654793a1cf08cf249ca8d6305535847a58f9115b9b2fab3b35f4291addcb" => :catalina
    sha256 "b2fe8a609d1dfdbc0c5966f06741866f7e1ce7f419172f2d1655877c47b18b3b" => :mojave
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
