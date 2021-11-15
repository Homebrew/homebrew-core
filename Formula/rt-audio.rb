class RtAudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-5.1.0.tar.gz"
  sha256 "ff138b2b6ed2b700b04b406be718df213052d4c952190280cf4e2fab4b61fe09"
  license "MIT"
  revision 1
  head "https://github.com/thestk/rtaudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "797faf66fdc3c2d026ff13be1af5557dbd0a510c9e7f47f782a91c6206790a21"
    sha256 cellar: :any, arm64_big_sur:  "6aaea7e2e041421f615e4a20a371e2fe9c4fe601a8d1e3da61e9820595ab7c84"
    sha256 cellar: :any, monterey:       "b532a285c9c97b52efa5519f2687f563e1f43b535ec8ca249bcdfbf9d021f400"
    sha256 cellar: :any, big_sur:        "80179e6294797448e1d3c70a23f42c8d64f1a45dc0b9d335af665143a65ec29f"
    sha256 cellar: :any, catalina:       "0d370ab05627fc2a81ca3893e9112c4fbc5282b4503e4a2d39ab9bb99e076e65"
    sha256 cellar: :any, mojave:         "b6a89413b4075ca42dfe7b6fb85e1546d02536dae94c5de5b23bbf231fde7247"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images]
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio",
           pkgshare/"tests/testall.cpp", "-o", "test"
    system "./test"
  end
end
