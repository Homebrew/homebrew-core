class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.6.tar.xz"
  sha256 "8351328cdfbcb2432e63938721dd781eb8c11ebc56e3a89d0f84576b96002c61"

  bottle do
    cellar :any
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
