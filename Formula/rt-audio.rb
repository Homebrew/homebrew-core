class RtAudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-5.0.0.tar.gz"
  sha256 "799deae1192da52cc2c15a078ed3b42449580be7d096fe9bc841c5bba0289c57"
  head "https://github.com/thestk/rtaudio.git"

  bottle do
    cellar :any
    sha256 "c3ad32ecc289ff770964ca2d89511eba3d184787797324219a8b68a78ed3f3dd" => :mojave
    sha256 "497769e931f08d51367dae46ad3f7c3ac52f7d87ed79698c4e564aed74433d4d" => :high_sierra
    sha256 "d573b5a8e5e832e4b10445a05fe7502e62d42b5f8ae74796944ef3b30af7c3eb" => :sierra
    sha256 "b47e9e56e72e2e7969f811e8cb11db6a4436e4f5b5363db917043083b8dda612" => :el_capitan
    sha256 "bd1920ca3ad3c0f67e7824b430fa32a4f48085a9bb7233e9157bf292d73bd099" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "librtaudio_static.a", "librtaudio.dylib"
    end
    include.install "RtAudio.h", Dir["include/*"]
    prefix.install "contrib", "tests"
    doc.install Dir["doc/*"]
  end

  test do
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lrtaudio",
           prefix/"tests/testall.cpp", "-o", "test"
    system "./test"
  end
end
