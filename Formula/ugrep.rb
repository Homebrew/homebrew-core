class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.9.tar.gz"
  sha256 "016e771756574a2a0b026ec50f7e7f3898d39cb61771ce98bc225c34d86a03be"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "68c8666ff18b551d93d997adc29e8fcfc083d11d3bedadd51100e550670c401a"
    sha256 arm64_big_sur:  "6470ad655905d666648b0f5f56c76fe9f27814234a2ef2006893853dd49fc070"
    sha256 monterey:       "35e63bcf04a6baef21c67c2a369ff955b896d6680da24443bc2891249aaab5f7"
    sha256 big_sur:        "ccc3fd69b29130a55a335acf99879b81323ac11a78c7108fb6dd1b3424bb3e82"
    sha256 catalina:       "27391e31e12e569335ce8f1674d9702d40883599491ac5aa619250722c6621e8"
    sha256 x86_64_linux:   "78467fd0ee82bdadc6cbf1cf5a89b4b9d56f8f6152d49c76884da77b645b5d77"
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
