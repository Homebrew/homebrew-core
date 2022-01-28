class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.1.tar.gz"
  sha256 "90c358f2fa16de9a183f1ef2c18965ad0921d41c8b870b70155310de7436a8b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "43fb1800c165cf26c8cddf0e4c9e2acf50c9538d2036f5c9dd444b53e3ff8f07"
    sha256 arm64_big_sur:  "2d38f4ea8c12536f1b195de066b2eef877e9b39ef9e607828d417f11fbcd8e28"
    sha256 monterey:       "1b388a134ff4ea7c2a68622d7296971ce1c751659f921612a98e8d531f3c753d"
    sha256 big_sur:        "3ed21224d7cfd4227074db6940559fb73aaffd813e6dd60a032ce2dc3f589e14"
    sha256 catalina:       "3c8411d6233d5528a2c5b72a68cf9a14521816632672162e06ee47d5e17d6002"
    sha256 x86_64_linux:   "80edfde911574a133c3c2726025bbedd6208c4ac4b408e4c996953d3e2e9f28f"
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
