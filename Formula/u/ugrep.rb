class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.1.3.tar.gz"
  sha256 "99bbccd7a192fb11070fa75f4d8adaa1379d0a27dd3cbc1f78e1bace1c2d0e46"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "0f1883c6106a8b6e4b043b0dae9d43b496f325b931c39332126d07b916b66f92"
    sha256                               arm64_sonoma:  "a72860199360b848a6e69ce321ab820e14b0739c65f07cf12ae53ca018ce588e"
    sha256                               arm64_ventura: "dfa1a7c0d0f587e3d106078d95ab38e426113dc4abf139f3af36f21cd1703b8d"
    sha256                               sonoma:        "0c48049a6f166da2a9fdf3b4f0a88e0a8ba5acfa8ca0ea4ad807754dfadf3af5"
    sha256                               ventura:       "075014c6a973386d94c2f82303469f4b43993ef7f993c0d36f97fb5ca5ce88ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54157fc16bb9d970a5da31dbae831dcb71fa25d3280c6792f75ec77017be1352"
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
