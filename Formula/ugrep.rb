class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.11.2.tar.gz"
  sha256 "a314cc6fe149eef9bc0f0d69c6b331d9d4491a100677c1b3fbb2159806cca2dd"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "b69f3689ce8d42c1ad5c6819a1eb1dfb1707ad300d1706bf8257a71e77998c60"
    sha256                               arm64_monterey: "bfc8f646834894b047c6fea1e7dcd9e0bd789949d5126bc1f05d09d620758ed9"
    sha256                               arm64_big_sur:  "6e1efdce8d9f2a453a66b84a2e6ac0172e1c6a5169a183884657f2f926a2b2ad"
    sha256                               ventura:        "a81f90ae6ab7cdb3fbe6e593aeba85803cbf737a4c5d47bb1b4bf40bc058b021"
    sha256                               monterey:       "ac648a2edf35d9224b688ed819223c61371be7a32761981c28d649a1444ed387"
    sha256                               big_sur:        "25a400f343f85145e0f6a8ea322c5a146c22b4814cb64c2735a4240c25ed5b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7f5956b5c0a957c358af68caaf4fb1e701a8cba7a95609baeb15d8c837c91f"
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
