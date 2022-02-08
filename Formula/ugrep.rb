class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.2.tar.gz"
  sha256 "ce36c0ef91cfd99fd3a5fdcbd0b04eae4b7dc40c7af8e3df67e732e9213bf28c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "ec155cd5b76bafdf2fee51e2b35cd950ef0ba6a236e56df4944df328cb4a845e"
    sha256 arm64_big_sur:  "775fe887b6dfc7c055480db132343c3d436cfa71ccea15c240899d114c539c2d"
    sha256 monterey:       "c32df1213c841fe89c6905e7b9e02fa8bd1f2deba99fd8f58e86c7e3bcf3ada5"
    sha256 big_sur:        "3c6db18f4cccc1a078de3cb1fd7f72e931d84416379ed091754588b46270d6af"
    sha256 catalina:       "2c734892b3948042afcac90829a45051a8bd2326234d412f7982cb697ba3ee95"
    sha256 x86_64_linux:   "3031243e7c7b7570fed0260e742484bd8a4f85fdf853a3c8c92ad3a0cab7fb79"
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
