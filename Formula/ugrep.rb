class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.tar.gz"
  sha256 "06d170fedef1f758764ea26e519d59a5e2396d7a8ed9c25deb98ad39b4e3ced3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "017585193954a3fe87ebce47ebd0314e65de81545023eec63d7613b4c8ed85be"
    sha256 big_sur:       "953103d33869dbbfd4e6c5f4a5c54a72f0439291a0ec61221d63603c24f08199"
    sha256 catalina:      "f6681fe840a7dded52455eb628d47d19a64393c6000d28f149e43ff73da31503"
    sha256 mojave:        "9cf43d434298bf9d4a02e900b8af8cb792f6f40ebe6b89b4d829b7b511e8a859"
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
