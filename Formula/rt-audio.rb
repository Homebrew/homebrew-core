class RtAudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-5.1.0.tar.gz"
  sha256 "ff138b2b6ed2b700b04b406be718df213052d4c952190280cf4e2fab4b61fe09"
  head "https://github.com/thestk/rtaudio.git"

  bottle do
    cellar :any
    sha256 "c3ad32ecc289ff770964ca2d89511eba3d184787797324219a8b68a78ed3f3dd" => :mojave
    sha256 "497769e931f08d51367dae46ad3f7c3ac52f7d87ed79698c4e564aed74433d4d" => :high_sierra
    sha256 "d573b5a8e5e832e4b10445a05fe7502e62d42b5f8ae74796944ef3b30af7c3eb" => :sierra
    sha256 "b47e9e56e72e2e7969f811e8cb11db6a4436e4f5b5363db917043083b8dda612" => :el_capitan
    sha256 "bd1920ca3ad3c0f67e7824b430fa32a4f48085a9bb7233e9157bf292d73bd099" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "tests"
  end

  test do
    system ENV.cxx, "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio",
           pkgshare/"tests/testall.cpp", "-o", "test"
    system "./test"
  end
end
