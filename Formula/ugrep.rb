class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.8.1.tar.gz"
  sha256 "0d1485554a4ea2bd887c7df365f9138adf185812bd65cce1293fc6959d71767b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "ee6a306026335f04c95366ad1422115533217750cb83a93b5cc67c62025f0978"
    sha256 arm64_big_sur:  "c1a4f3d2893d663841e643a56b663ed4598aa59590d320391f409168570f296f"
    sha256 monterey:       "0cb4395daeb6ae1c42086e4117a6734e0df77790c5dd69fcb9befc0a3f7c00b2"
    sha256 big_sur:        "b30be7df27d9256e810d3e6641242beb7b6b4bef35184ee7edb8c5ea82ab08d0"
    sha256 catalina:       "5c36fb7fc63bcde68a362ab1eb78fb0a4509ace2adc391db90666a70050ad3c9"
    sha256 x86_64_linux:   "99a8ecd7a23d415fb6e5474ce749fd06ab24402a57aff679ee7850b4da77111b"
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
