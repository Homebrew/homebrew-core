class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.5.0.tar.gz"
  sha256 "9f8469e111ee665f6f03e3a8c0e4b06e632ce3fcb90e955b8979696973cfa0db"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "0206d7cec3cfae36e031247a5e3e69453dddc42e9a2c515f0171303009e81b7c"
    sha256 arm64_big_sur:  "8aea7a90e6c2048b4037cd07b5a7e005f58824f12eae094f7b818a0b8ea8d673"
    sha256 monterey:       "d370f9ce5f0adb063f28c1c1e70e1ebcb8644a89f6f0f64e08a5b84a8bbf279b"
    sha256 big_sur:        "f632080bf54d1aba523318fd31de38f357c32d19b3392e82a52decf599a8a845"
    sha256 catalina:       "f81114ac7508f7a3cbbe3f9bdcb455388a62a808ab2e9107ebdbdf4500a2ee92"
    sha256 x86_64_linux:   "3bc19abe33d32c9434a9cb145476f31083d07e566e6fbbba1aa98598373b9627"
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
