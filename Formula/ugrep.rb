class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.2.tar.gz"
  sha256 "ce36c0ef91cfd99fd3a5fdcbd0b04eae4b7dc40c7af8e3df67e732e9213bf28c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "05662a9f0657379838f4099642edbd9ec8abe0bfcb6f8e17a643451dd6fd574a"
    sha256 arm64_big_sur:  "4366eed0cdb4544d0301101e1d0eb973c2101bb5a20d51e3389921f58c70a15c"
    sha256 monterey:       "f9b09017842ef3719d4e444d85a2aa79ed1f1b01de2e392678c967c207ccaa2e"
    sha256 big_sur:        "9e044d372f75fcb2e45cee77ac4923cd86661cb02263d8e81bdbbe58b9fabf4b"
    sha256 catalina:       "e045bed4ffc4587b97b029c72b7a25dbdad68a91f222bbfc2674e3301522de03"
    sha256 x86_64_linux:   "29f86374ad163c26d69121e560eb2a565dfa31f86c6cb06198cd7a5d015d6209"
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
