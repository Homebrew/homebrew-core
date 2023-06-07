class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.8.0.tar.gz"
  sha256 "deb9bdedee2aa8ad0e1e95da4c2ffdfdd0d205288ac3c9ae42c770cec4df6615"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b203442ae6ea0f20f0e4976a755ec08d83534cd51818f4582d1da7fa7fb95b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "424b990c816022d4b778e7524b3488f242dabc0bbf306bc090d4aff2ecc0bb27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04cf13948e6fa8160a4bdc51a53d0712beeb5520d52096375883ccb9c0f69a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "6141b5aacc588f176a65deb2a2bdce878785bdcbc615d9ad4a4d2d4247f26201"
    sha256 cellar: :any_skip_relocation, monterey:       "eb872918fa407b197916ef2489aa35ab444a4092828f55660244b4bd3a3849fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "393b7c5b14914cb92c22117c86a03a37b4f353457a4cf8f9718d6f6ddc645eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d2105a5e0b6fca0204c8270800bc9097c464e2a37febbaadc9ab1f273396e3"
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
