class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.5.tar.gz"
  sha256 "f080ab6cd9d96a5357570cb60a99e09ebe5eef11cf322c35373dbe815378a1f2"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_golden_gate: "afe39938ff337878063ba14bad8e0d0fdb3d2f3a42320aeea53b90a3551ba5f7"
    sha256 arm64_tahoe:       "f7d7552d1777de106c893f49f6ec792d69bcc9a8eac6af9dbd78df2cd678faa1"
    sha256 arm64_sequoia:     "0f329a1b4bdc06c6775bc09bfe32a040929d957f367ef02198eaa8b58e1b9b03"
    sha256 arm64_linux:       "3229016a379629da5236b569ada6c3bbdf20b86f71b703447f9d9bf497b2497c"
    sha256 x86_64_linux:      "ee0050a426e74e01c03fe6d98f19da14c4a46cacfb2c9e862781ee6c997a46ac"
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
