class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.3.0.tar.gz"
  sha256 "523c69aabd304105b6d7db7f95fa7b50715794af6e000a0f705ce533026af977"

  head "https://github.com/thewtex/tmux-mem-cpu-load.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82e784c1cfc1311cae4e696522dc89c92b0eba5ce847fafe62abeb85516238d8" => :el_capitan
    sha256 "57b1b66ad50d59fff39bd4bcbe7e6729b75d53143de2df5d41445ccb63783a0d" => :yosemite
    sha256 "432a3ab49d734ea72a7fc16aa6a51bd6c7c74030700c0220ef21d58f09b2427d" => :mavericks
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
