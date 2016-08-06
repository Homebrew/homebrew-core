class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.6.tar.xz"
  sha256 "8351328cdfbcb2432e63938721dd781eb8c11ebc56e3a89d0f84576b96002c61"

  bottle do
    cellar :any
    sha256 "927127881787a7fcca21226eb1072f95467e82d452850fe87510ca9d67196ef0" => :el_capitan
    sha256 "69444742bc7dd30b001febea95b52943b39037241622e19e331aa97af17d3d5c" => :yosemite
    sha256 "a04a384e25bb191d827ef07694a0ed27636c2e1cc99162dd7efd30c3cad6fb6c" => :mavericks
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
