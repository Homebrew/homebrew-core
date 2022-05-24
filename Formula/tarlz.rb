class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.22.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.22.tar.lz"
  sha256 "fccf7226fa24b55d326cab13f76ea349bec446c5a8df71a46d343099a05091dc"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4807d9e8a4979583eedf6bb8e561ba705036b1755ce944c3f3274031fdc97c90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a4e38f8048c511ee21347bd7cbdf8cee713859157a0823282560dbcf597da01"
    sha256 cellar: :any_skip_relocation, monterey:       "c6be6c9691c1c1efa83e5e360915444815dd7a61dd4fbdda58bf86fe80562887"
    sha256 cellar: :any_skip_relocation, big_sur:        "2624f5d7d11c9e86385db7ab5b2c467aca81ca9faf5af61e270043d2516baea6"
    sha256 cellar: :any_skip_relocation, catalina:       "dc15b0f77cf793cc3ab3b74b28587238f069074da674b4b797ff173c5b6ab309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54e340cd05fbfc963ea86d42754078249f79e74328f42e178b63d61f5bf4886"
  end

  depends_on "lzlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    spath = testpath/"source"
    dpath = testpath/"destination"
    stestfilepath = spath/"test.txt"
    dtestfilepath = dpath/"source/test.txt"
    lzipfilepath = testpath/"test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system "#{bin}/tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_predicate lzipfilepath, :exist?

    system "#{bin}/tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
