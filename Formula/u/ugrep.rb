class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "afe88bdf4062239df240aaa2b4c788bb4282f554dee0982010bb3d36ef29e1c0"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "6f47d110903e10447c9ad8a00908f6a830722365ca4a91efaf52cff54ec0ee3e"
    sha256 arm64_sequoia: "2b49e49e27a3b0164cc35ff34313ed647d7e8b2bbbb67ee5ef66a7c9350534a8"
    sha256 arm64_sonoma:  "5dcbd6a3036d2ae8d757969ea76f9cacee9c8b5689af8519a4dc804d41df06f4"
    sha256 sonoma:        "2c38a20711410770d5315f6c27bbe1b435f6ce04e34c15428b7057ba3e510eab"
    sha256 arm64_linux:   "0aae020a5a0fe79bf62c1fa7ffe6cb1698f0060691c71bc99a367a845f56f0f0"
    sha256 x86_64_linux:  "6cf97fe3b33ef1ef4f9ac70cb54085e66f462c4060eb35a0c16cbff7777689f4"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
