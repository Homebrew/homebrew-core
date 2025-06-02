class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.4.3.tar.gz"
  sha256 "105b495f4d2773802b5a71e2375ba07bca4e67fd6837e5fc1d00be5cf4938f16"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "e451587ccdfcc0a15454bebfca1a7f2cd0fc12a78e3491e443f1dc58372566f5"
    sha256                               arm64_sonoma:  "7d4b883ee11da8b25b2f61ec5d026dbe77674339782064d133c1d6f1eee1d6ee"
    sha256                               arm64_ventura: "1333f5203fad9861ad274d1889da6f49c962dfe321b9d6050ea10c8f32471a1a"
    sha256                               sonoma:        "eee3d694c71c94412d2ca08f1feee134af9b47556cf6bf7a9d2bda93c7b7df26"
    sha256                               ventura:       "d35a6c5b6af5957056b62c3a7a50e0bcdc9b95989bedbdbb36426829c85b7bdc"
    sha256                               arm64_linux:   "d300b60a9392d49aefff176bc28bbbd9d40bdd98c932e52d20a59827c61d891c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebea2ef0eec2b79f8a62cec80e50d32b27df9c461cb0222138943e58f200e70f"
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
