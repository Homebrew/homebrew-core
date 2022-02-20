class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.3.tar.gz"
  sha256 "b7790dc746c8f7902afb2c6484aebbb11d31fb5748955acc177715feb10502ef"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "4a6927daf7a905f8344d2c442f789395c4af7160bee09c3e2bdf4adf89dec025"
    sha256 arm64_big_sur:  "5c970cfc01b3a4061eb8aca82537df171f28c4d9dd3463dfd739f53f2dbac8ee"
    sha256 monterey:       "37ebb6f96b241c5e4ec8dabb215685978cbd2d61934e9b3d87bff763acb38e7a"
    sha256 big_sur:        "b8cff2378b59f17fdb3c64af4142ea54bebad9246a225f2d9aedd766afa65aff"
    sha256 catalina:       "a380621a3ddbd2ff58438de165d129cf4c7094ffec08fa105f58c63297e9ef15"
    sha256 x86_64_linux:   "2b73e51336aadd95a9066f371ce90b1b04ec8a6416102773006157ba14c5ebf4"
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
