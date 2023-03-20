class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.6.1.tar.gz"
  sha256 "eefa5f891786b0d556db57179279a353dcdcd6bdedc07070b1e27c554477a420"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcde6fcf8c75ab2d649bd524389d39f099784836fb335b307fb5ae4023797e36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642bca3a0a594f0098983d20caff51e533a749fd7c461c5039a35b9f12931ee6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4104dc3f30b90dd5c192c8e9208d598f0384bb8161be9d9aa558cfc7de1d3e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "dcadca600d176e98c13232a0b311f8377a7b6c6fc7b27746c6595a2cc0142edd"
    sha256 cellar: :any_skip_relocation, monterey:       "b7a648194d99c69f54d9e84623eb736b355a013754f45133cbc8d0427659c5c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bc2823a89543a090032ca0993b63957246a0b7eea35ce510fec7fba541daaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4a62c764592161d1a8bf9a18b53ed93cb5e5f8accb704e634108c9176ea930"
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
