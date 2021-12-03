class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.10.tar.gz"
  sha256 "8cf74bdf254bac78c19385028bbf8678d83be35522d452b71d16105a1c4c57b8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "1a1a330e8ddbcad040ee6e27feec14c3a764f487c2ba05820690384eec77d4eb"
    sha256 arm64_big_sur:  "fd513b88aaa6f285a97555491fea561598f07b6f4b59b5b7411dce853f20f134"
    sha256 monterey:       "6b4f045a46ceb962f0121861d701734105f27546f3d3f2b795499fabcace5191"
    sha256 big_sur:        "a85c9166990bd812d422ff845a72a988a08529f45f8648e41c6e9d01116fd65a"
    sha256 catalina:       "177f51f0afdb20f2f46c41c00b8c850461847b7be99e748427c890da7eddfeba"
    sha256 x86_64_linux:   "8f538e1a53fc84dbd8edc1dbc103226dc14b36355a55271313b40584703f3346"
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
