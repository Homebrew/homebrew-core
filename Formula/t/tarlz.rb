class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.27.1.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.27.1.tar.lz"
  sha256 "7091968e8f9b5333730e7a558ebf5aa9089d9f0528e6aea994c6f24a9d46a03f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4911dacbbfaebef7ee440b13fb73f79150ee27cc267ea58b73b5fe7e2ffd61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361d64c7b4444195ab44b2f8b3162a549eb40d69a960a5e7881d9282b0484e51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af36ca5f1dbfa2b8b625cb584ff30a8094735383c604b32c9afb3d4b074b75e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f707b108966d4e44a95c02fc0cf57627961bb6effa9e0f5c71c157cfdf96cc0c"
    sha256 cellar: :any_skip_relocation, ventura:       "c0facb62b58f1da43b275032ab7ead7e2ac2c6210590ea46185a00f14c977331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb3e6380916c128b56719a3edefa725ab0bca627b7df0db6312ce2ab2f4146e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda3fb03bac16c1a239cf2c2dc9328d7b05035d494641305fb49ef8e8a31dd5a"
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
