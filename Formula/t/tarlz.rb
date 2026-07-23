class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.29.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.29.tar.lz"
  sha256 "7e127f1e1b1b62ca6e3417fde32f3ae0481ba5886f56a8553a215b19d81c6c19"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "335d682a3b430cba57a287119c7e87b46f1c90d6a50bc426ea6312a33aaaafc1"
    sha256 cellar: :any,                 arm64_sequoia: "1f521f67485ce19c2224ce90ddc08c1a21d12c1bb0f90b0e298ea0faa832f544"
    sha256 cellar: :any,                 arm64_sonoma:  "193f7909ef30f70836db95c0f28593e2f4154cf90a8addebffcefec1bec4137e"
    sha256 cellar: :any,                 sonoma:        "d45112e00709bb96c1a60b4ca33f789a5f0e1ae6cf26d9b356173a8dea5270fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762ba14cdcc171ec8f7e6884f7fe4ba7d21e916d0ed95cfd6cac379c9850b200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55b50e47918fb42455d602c9c900d851c7ff4875cb8fdfa06e60f46ed25b98a"
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

    system bin/"tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_path_exists lzipfilepath

    system bin/"tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
