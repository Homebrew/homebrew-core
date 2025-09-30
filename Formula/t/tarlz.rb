class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.28.1.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.28.1.tar.lz"
  sha256 "ab3c92b7f7f10c9539bc7be691fba648af21d4c89e55d81ec66d761f8dd8b5a9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75626336deac9be501e32bfe2f05fc391b56ef668cc6674da26a0dfdcca6ed88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ad4e0ffe9444a31b9dd00c618834f3929a075849575310215035d689fbac9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ed3e0ca784a60679dec53ce55dc8948b81bb677fe5cd91d7f7847dc602577f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe03db2f1b10579d8ff7bbc962ab84351ea9299d9b19ae65550c9fe799fca8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc7b46bdef760864e10f7922512fe8b4922cb196443488355f2fb1be31b6304"
    sha256 cellar: :any_skip_relocation, ventura:       "8bc7f3fcd10fafbd3f675688a34db7590539b7ea40f51202febedbb253e1ed7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c6814a91403d1f9b976d9b803497b997fdb857aa2f25a4682d5a231b4353b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7dead1614f09e2a87c8f2cfd49baa970780b82b228f07bfd9dffe45ed84ef7"
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
