class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.7.0.tar.gz"
  sha256 "2acebb82125109c0ee26744de0c41620d1cdf6b884cf34b113165ac13b73d55d"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4244f3216ad6698f3fcb0ed4bfcc4fd013e22b41b97aa076803f18dab5da49f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6880d7ed874e2c6c89020f66a2c48f7aa05940ad9af966eab779023a0d782e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76c0a1d2714153c86e02c1a252a75e73c846052457ce4b261c137e206ee5c280"
    sha256 cellar: :any_skip_relocation, ventura:        "ea85eda701b26b25da5404dac82a76cdd9d665d6d35e79dfd651ce658a2f692f"
    sha256 cellar: :any_skip_relocation, monterey:       "d937d2928553daeced5ee8326f1500ed4ae2b43fc70198971ee413b2913fdc33"
    sha256 cellar: :any_skip_relocation, big_sur:        "f389a6d7ab4f906eb7b104627dec5105a074088645906a89f8b6f9f67913d223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd11ddc300e125efad692a9202ecd908f353b4c3f27bb3cfa8a0d78f559fb39"
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
