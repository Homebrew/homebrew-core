class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v4.3.0.tar.gz"
  sha256 "a3d90690e6400ceae5ddf80c344c70d49f402fdedac636d430cfe0764eebdb1b"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "c72b3a6a5885d5932c647bf159f6e79b4dcfab59f1efafcb6f9742bdb6634a0a"
    sha256                               arm64_ventura:  "847fb57203bb1039db733a33c13df027bc44b594ec62462890f157aeb7245a9d"
    sha256                               arm64_monterey: "85c894b2aca309ed996ef9367de10bf8b30516d77aa4f62624fc1485ca50fc72"
    sha256                               sonoma:         "9fcf0698b804a6fbbeab973d4d043f985e4243415087002ef2b79fc03e86a3b7"
    sha256                               ventura:        "8d19db58011361d766521d109a7b2af57507f672f55742e445c0244e9ac397cb"
    sha256                               monterey:       "d8d340e7251805a069e989197481ddda651635d79716a9feba52f2b8ec7cd0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7deea93ed66429566122b708a8328d5b2b676c1dad71b5fdc020c63835ef68e6"
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
