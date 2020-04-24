class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.7.tar.xz"
  sha256 "3fc79408ae1d84b406922fa9319ce005631c95ca0f34b205fad867e8b30e45b1"
  head "https://anongit.freedesktop.org/git/uchardet/uchardet.git"

  bottle do
    cellar :any
    sha256 "83fd5ae3ce1597de3b2847f979fbc92fc5b95489c48637efcb3afab5620d2426" => :catalina
    sha256 "d276b3607abe2ed5e2922cda3572d09192c60f13bf18d6d84cee24c12d700bcf" => :mojave
    sha256 "c0416fb559e8c10f1cca21a0b0162d462cc02019d8abbce3712f64261b1ce8fe" => :high_sierra
    sha256 "dce2d199e163858a10f27f9d94d232b8df5d38507098b629356ee5154d4f182c" => :sierra
    sha256 "998232b6d034c090680202ca6d48a9af4924f091f3b597e4aa318f87fdf29bb8" => :el_capitan
    sha256 "ab930a4e2c217362dc7e05940cc6449d024f18c5014847ff9428facef02316c7" => :yosemite
    sha256 "c02f20920ac97596ab425b057275372a77c80c7d523191f2e5ab78c636d6827f" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_equal "ASCII", pipe_output("#{bin}/uchardet", "Homebrew").chomp
  end
end
