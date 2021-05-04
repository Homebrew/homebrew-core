class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.2.tar.gz"
  sha256 "e5b4d7b2e4a87b34416200d068dc1984967f980418670fa6b08268edf00a4a9d"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "5f728e0d50ca4865f0bacec1e640a1b080c85d1fbf7e22405b2005d58c8ae584"
    sha256 big_sur:       "694549c45b52e4d79f4e1c6680bb632fb835f3290ff9ea2d466602ef3d169c0b"
    sha256 catalina:      "83fedcef66a3f2bab0ca0e0ddccc767f0694f8f850137127e019c5e668473948"
    sha256 mojave:        "19fd8c006837bfe22b8c687974de550c3db1ee4bd98c839690958c17cb8bbc9a"
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
