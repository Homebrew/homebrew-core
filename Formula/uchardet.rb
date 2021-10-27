class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.7.tar.xz"
  sha256 "3fc79408ae1d84b406922fa9319ce005631c95ca0f34b205fad867e8b30e45b1"
  head "https://gitlab.freedesktop.org/uchardet/uchardet.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6f144a202080194afbba458511b7250a27a5b0ff5f0baa4f81a4ab4148906aa5"
    sha256 cellar: :any,                 arm64_big_sur:  "33989aa08f1ffc6f71f536c2a3cb28aabcc774e90da2aa40db110048f4b38238"
    sha256 cellar: :any,                 monterey:       "2b32584a9ef94d89025ed7b2d027608013571f12e30b363fa46bfddd5aab2893"
    sha256 cellar: :any,                 big_sur:        "f5125cd193034470e278536d8b5d2498e99ddbd5c2853e214fe24fe845cc56d7"
    sha256 cellar: :any,                 catalina:       "34bd4791834a762da961de136a3cad253800a98deea2d1dededf8efb465f215d"
    sha256 cellar: :any,                 mojave:         "a254139ee777de77d5907dfeb47d4306f2e5e5f0b3775edfedcbf1fcf217fdbe"
    sha256 cellar: :any,                 high_sierra:    "a89237dd88e4190826ce6fb4a8a625711636db7d6c4ba10d5ddd56d37347e868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a85799a4ea86198a27dcd64601a9bf3445baa3dca32762ca6616c9c78a79583"
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
