class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.4.0.tar.gz"
  sha256 "a773994e160812a964abc7fc4e8ec16b7d9833edb0a66e5c67f287c7c5949ecb"

  head "https://github.com/thewtex/tmux-mem-cpu-load.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8743cb844ff2a55657f2f1eb7bfae300c02a3fdf255fdd5e8242d1a60103838d" => :sierra
    sha256 "9e2c7e5fd03feb98cead3f366a9cc35375cee80c30fd570c742440d69319c296" => :el_capitan
    sha256 "abd6293238671268ea1f0362518cd82c4b3133cb42b0327d579c93768ea81110" => :yosemite
    sha256 "24e52a177d0201edf30621a648c7cbbf1f2cc7e4bd9f9145a7f8c258d9219725" => :mavericks
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"tmux-mem-cpu-load"
  end
end
