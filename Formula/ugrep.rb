class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v2.5.1.tar.gz"
  sha256 "220b33b4d7f9814f8de4e61cd8abc3c26270dc42b923b697af1fe186e5173dd8"
  license "BSD-3-Clause"

  bottle do
    sha256 "fe7ed295538c51459e4dd89bdf47cf5bef13d8707f1ba74c5b563134c48e6811" => :catalina
    sha256 "5188397bf07fc26fabb0cb417cc4f017b08693164c81d4345f5830a3a814767a" => :mojave
    sha256 "d701f4a1b01d3eafd8d44f2a468c975d47cf6ede9c0afb82f5303b55187453eb" => :high_sierra
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
