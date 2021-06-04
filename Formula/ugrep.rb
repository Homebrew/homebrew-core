class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.1.tar.gz"
  sha256 "65d8ff9784630d25b4e4fadef6bd1f60ddcff206fbb38f756b42f0c63c6b2c23"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "a51cc5afdda6ac8b32fa1bb75002c27241347ad14bade2d0756dc2dae516f6fd"
    sha256 big_sur:       "3cac2cdbea43d69fab1856fc935b8604b8ba721d4250ded9d8b782d0bdecc7df"
    sha256 catalina:      "84cdb5c42c1f050d38180e606e476450d340dc4ddce1f455b950fa0f521764cd"
    sha256 mojave:        "64fbbd4df2ad154b6226117dc3926bc8225f505ddb6b9f38b232090fb3b29132"
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
