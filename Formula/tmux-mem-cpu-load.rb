class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.5.1.tar.gz"
  sha256 "6b62197ba755eec775b3f494db617b239b5e9d79945e165a3c8bba3b9092d0d1"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbb889c3e0ec08b5df100218c625f65681c3381d654a4ae010597a9303a4d89e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4431aaf5a11cff153ac1c2ace3f664704f6c0cbd735c85d1ee5f5e0102149a27"
    sha256 cellar: :any_skip_relocation, catalina:      "725b9b17bf012ca94e469852c5144f7c427ac88076fb53f1c5af860677882151"
    sha256 cellar: :any_skip_relocation, mojave:        "f5398f18c016a0bc376918dc3e57eb0a4406dd3b01dc98c18d64f4406ad61830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37649e0ec8e25e2b5f20b2e6e5f02b19eebb78a98fcae833f9de99f3e711f567"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"tmux-mem-cpu-load"
  end
end
