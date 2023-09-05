class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v4.0.5.tar.gz"
  sha256 "d1d1713d17e4265a042b304202a5189346fad43aa73e62807a7aa432f3ae07e5"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "08b2964dbf5e38a96629cabe921e972d689b8c3ca27d4dd20216b9864e189a31"
    sha256                               arm64_monterey: "2eb1b309a3e85636484c4c4460fdaf9628e1cda98b3ccd922ace1b4a3cfc08e5"
    sha256                               arm64_big_sur:  "44550eddb7b21d1bffb0f78ab8df603ddfe29c1656a61212925dce7745db6e9d"
    sha256                               ventura:        "f22995399926eca930a247cbe3494fdf11d46eb06c793b2d9d176f0e5a623702"
    sha256                               monterey:       "c084539a7f578f9a9afa4d59ebcd1320215a45fb190a90c9f56e8175544b0628"
    sha256                               big_sur:        "950926fc3a0ce663b342eb43d0094c3d72ec793f35f6adc4c38f2f9e8a6b2392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53ec6ea584bd474a6a9791ac3f80f8d1f1b4c6e0cd6042b2dca009af7bdb9151"
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
