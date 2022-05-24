class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.6.0.tar.gz"
  sha256 "7f63e12052acda9c827959a7098c11c6da60b609b30735701977bdb799a43c42"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908d9ef6772534f3e8566c1ff88df907e58586ad052f4084fef24488e4fa6f01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2e38a29b73a3fce05d2f15036d16b8f036d27a9b2f7cdf6bd6ef91b6ebc9bc"
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
