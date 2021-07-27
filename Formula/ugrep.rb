class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.6.tar.gz"
  sha256 "a536375252af0fb82b296b238cc3e45851f526283a333ce41390500e03a42e24"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "9b3d0ebc1cd3698f9fb9d547b0b54b8674833c4f2e0274754e02e0a43f0deac4"
    sha256 big_sur:       "bb1ad96936d0e3116be7f55416a6dbb0e4ad8083c1b3bb11a3354648f54b9847"
    sha256 catalina:      "2b7f50075586b2219220d19a3d9be44f24dbdf6a8c815ade21229653e0af16c6"
    sha256 mojave:        "ca7464f172875ff0f6b10b3e18495bdd34ec95b2f945f45d64e9591545acce2f"
    sha256 x86_64_linux:  "6fbe537ed3b96973b5ae80f99528d2eabf161e363d073702a06430dafd86167e"
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
