class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/refs/tags/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"
  license "ISC"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5f6897931983716f6fe5d478b09f57bca507eb1cccce61b78dfca5bc8722d683"
    sha256 cellar: :any,                 arm64_sequoia:  "d8e03677d759133baf47f323bb3ca630c65cc7c66e53809ae8cb2458ea6e65c5"
    sha256 cellar: :any,                 arm64_sonoma:   "02a4646315bc8a2391938a856635056e7b64b372b6c2607960911eb772229bf1"
    sha256 cellar: :any,                 arm64_ventura:  "cb4f278f194339e85a3e75b701c29e471b718760ad14bb10580bb546a3314e89"
    sha256 cellar: :any,                 arm64_monterey: "0ae6b6e42ee87ba89102282f21f1b7e4bbe98ded275f363a91e47ec9f0ec3cb2"
    sha256 cellar: :any,                 arm64_big_sur:  "3df140d14c8a0c8247e1157ddb05ff9e5249b7115e26871c0eb498b43eccc180"
    sha256 cellar: :any,                 sonoma:         "4585533c56cded0abce37fda111fb2154d3c8b77cac407f6e4e85c243e8bc129"
    sha256 cellar: :any,                 ventura:        "77ab7ae23d1ee2add50645d344474f641c21abd8da1df66eb84b0e312a41cca6"
    sha256 cellar: :any,                 monterey:       "80039b863040ebc5f7868d5331c358ee3ef0f210520eeb45a11cb746a406ebd0"
    sha256 cellar: :any,                 big_sur:        "bd5b088f08568c294627c010ca998e811a6ff11251299fec4df84caa35db8c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "69ce08a03121ac9f4854a7b20a9728a24d2abe573045d5664daeaf0962ee27e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c16e66fef90676d5b183e53657435b8f97e2f80832391edddae38ee523c02a"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    bin.mkpath
    system "make", "INSTALL=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    system bin/"tiff2png", test_fixtures("test.tiff")
  end
end
