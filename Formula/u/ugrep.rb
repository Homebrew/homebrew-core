class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.4.1.tar.gz"
  sha256 "4e263e226dfb768ad82cab95f6fcfee9af41e53004b12023d3c42ce36760a5d8"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "33269867f8631a2c2facc91cd45f69b38ff9622668dd95ec40d8e55e7310b11a"
    sha256                               arm64_sonoma:  "2674c3ef8d8c440736323f0c2b1e2bd9663095cfda82cb08534f3d5c84eeeb8b"
    sha256                               arm64_ventura: "11547ad352c898cd2acb5384b395b63278b7c8d880f21d58e8172ed983f0d645"
    sha256                               sonoma:        "16c0a16ea4a80f656837a752ed474118061263ab0a1c1fc104603742e0eaaedc"
    sha256                               ventura:       "349bce51ba02ffd64c20d2c49156ec605733bc91eeb889b11ab2cde9e02ee6cf"
    sha256                               arm64_linux:   "cff8ef96cb425d890651ed7c6084b415985fb4bd5ca3f88fe74163b73e70e22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4862aee98c44fa3c2d2e483dc8c0ec064a431b54cde55eebf3e9b105044dda1"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
