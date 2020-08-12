class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v2.5.2.tar.gz"
  sha256 "a7b7a7db99a24b6191d7e381c536a88998d995f2ccd308ea5aba015155f8be6f"
  license "BSD-3-Clause"

  bottle do
    sha256 "24bb809190ce247d71b18664849a347aa63ecbffbd420e847d0d000f993936b8" => :catalina
    sha256 "40a5d54d8fb333a4f4c8ca6201feaabc541b0ae1237488016f48e3065396fc4b" => :mojave
    sha256 "da473d5e05da82e5da7b151b59ca9bf4cc38ae2c3c3bc4e075fca2bb4f3b97d8" => :high_sierra
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    ENV.O2
    ENV.deparallelize
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
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
