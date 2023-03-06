class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.6.1.tar.gz"
  sha256 "eefa5f891786b0d556db57179279a353dcdcd6bdedc07070b1e27c554477a420"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9798b520b479bf17689a722ffec29a27254b10e80d3faac2be332117065c92dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908d9ef6772534f3e8566c1ff88df907e58586ad052f4084fef24488e4fa6f01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2e38a29b73a3fce05d2f15036d16b8f036d27a9b2f7cdf6bd6ef91b6ebc9bc"
    sha256 cellar: :any_skip_relocation, ventura:        "4d6371eb1cafc7838aacfc1a7af60ce7761f402a126ebe7e3010d5dea647c5c6"
    sha256 cellar: :any_skip_relocation, monterey:       "8f39a31907df6aeae2afb43fa5cef232b8d72071a1c60bc64e6119ed1095a6c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a82c0e8c8e83db238bd7e9c1f2a32c4de993f456a299364a9f26107f2f43b4"
    sha256 cellar: :any_skip_relocation, catalina:       "a7f743c3c85cc40204e88c1c0b3a101a7f16d37d90e36a0517c04d33e7424406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90bdd3275ce43b439aa7879aca9086d71188e2ac453aac8a5acb88d794f99f8"
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
