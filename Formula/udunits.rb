class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"
  revision 1

  bottle do
    sha256 "98494853cf3c9763f511e3f4d1daddd29cbcf8c8a91c4716ed5951e081753bad" => :big_sur
    sha256 "11fbb852b729b417f5c3cca75fcf53b30e5e662638ddac30c59c699e04ae7c75" => :arm64_big_sur
    sha256 "b325949e293c7e881bb468893a84e75283587af9ccd21595874eec515d778b9c" => :catalina
    sha256 "4994ec2de43dcff6c6b74b3d7ec053cac4ad475b8c4b95207e7c8b999b43f884" => :mojave
  end

  depends_on "cmake" => :build

  uses_from_macos "expat"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "lib/libudunits2.a"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
