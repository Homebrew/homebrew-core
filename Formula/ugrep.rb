class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.9.tar.gz"
  sha256 "016e771756574a2a0b026ec50f7e7f3898d39cb61771ce98bc225c34d86a03be"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "ea43c74a3a16e96af72ccd7891be4de0211269a8a12da28d00888e7e8b173db1"
    sha256 arm64_big_sur:  "4e1b805b8e5bb69666e169e5c6fa3f6e3aa4fd2247e2de6b0edfae14105bbb65"
    sha256 monterey:       "6ce73fc794d15af836456da90b1e7f106a198acaf4ebd610a31a082b84c3459c"
    sha256 big_sur:        "944661a2b9c2983cb13d6d99aca4c4729018ee14472c239cb38549fd688177ff"
    sha256 catalina:       "19db5176e86947f1481c30353f0f4afcf77f44de4ce6f847e939c9eb1355142d"
    sha256 x86_64_linux:   "a84436b5e7dc0b3eddb67deef54a02094f58519f5b99c017f34f1252d346c55a"
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
