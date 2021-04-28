class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.14.tar.gz"
  sha256 "5fc446306d786641bce192f09a51f6126d6941aae54dbbbe85015ecd8659b220"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "ffa4faa1f9d5c87d41377d05e593f59eb42f557b7b1a160e85ea7adc11c82ba1"
    sha256 big_sur:       "41b9c6046211133c8529ec9e180227ebf30efe9f82f5d00585e67b63a3529e4f"
    sha256 catalina:      "5754ce1be95575c050e70988db074897c9ac5691e9ad5d5929aa87b1b1163a92"
    sha256 mojave:        "293e2835870b20bee8b486b0a9ff05169a2c77aa7157a0ab026e324f83d0ac81"
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
