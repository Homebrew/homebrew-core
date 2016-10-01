class RtAudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-4.1.2.tar.gz"
  sha256 "294d044da313a430c44d311175a4f51c15d56d87ecf72ad9c236f57772ecffb8"

  head "https://github.com/thestk/rtaudio.git"

  bottle do
    cellar :any
    sha256 "2ac9c8d3abfd8d934081ec1c4c5e52ae391e22d6cd29ae16272a2e698ea07763" => :sierra
    sha256 "8289fb90b4b4f8c9c41856c60683db91b0fe65a063a31710d01ee3f724c74b70" => :el_capitan
    sha256 "ec92e93d2452d3567e2bf193f4319b9ebdc9bf9be6a5ef675a413c8931b9efee" => :yosemite
    sha256 "4636c591bca5a5c3f012342ae6a92332f12a0509999bed90b97fe1df8632a699" => :mavericks
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
