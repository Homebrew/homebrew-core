class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "587ebb694dd3d2f5bef9f35df5b9e196b89da981cfe1084539e55b8d9a62fd65"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "4d191ef74a4af3f069a8deb1aa60d6e39d337384f025210c6322afda1ae17d8a"
    sha256                               arm64_ventura:  "ac3d3a0dad831ea12798dd124c45a2bf2175c36c625a64e3256587e8076b59ff"
    sha256                               arm64_monterey: "a0cbd7f5995d40684f9923e62351f47fd826a40bec4f25035201441db3625dfa"
    sha256                               sonoma:         "b2cff38f9192f55b9070117427a03c3cdccbd1c4135bf3d06fda28edae7418fb"
    sha256                               ventura:        "f4c72f01bbf4a3d5bfa3837f52084e7d10f3a5e6789210ac4cf1cc0769a9e105"
    sha256                               monterey:       "31b4dcb63e2f122bff76bd49d1b1454119fd2cc95fcf939518a4e04924779677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fcace7753331fe87ad1a2db998c41c3178d90727ac900b31e74624ba9cc9169"
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
