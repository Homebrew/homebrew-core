class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.7.0.tar.gz"
  sha256 "2acebb82125109c0ee26744de0c41620d1cdf6b884cf34b113165ac13b73d55d"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe7629538a1603fb7f1ac1365e6c79da2a9f5eae5d6a725d96fc91a8cbea06c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "001f75aa6b3b1a17c8c851725621c7cc1194d2c3ac2b2302aa769136268bc312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c53a80de9b291a54bd1de90701b110ee3cb8c1898c25a443181fef702f4fda1"
    sha256 cellar: :any_skip_relocation, ventura:        "32f48bc25aa773638153ad40f70333f756907737d1c5936d07bbc4c4c229aeb2"
    sha256 cellar: :any_skip_relocation, monterey:       "eebc6d9053a5bec71ccc7eb57a680126db2bf2ade9c07285b72ac7cefa09b80d"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c1315b22b17cecd59d91b744444de851515edef3c57310e2193d36c2a66725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47fe625e08833584dfb3f0fdd2108233db639e9beed8c8293b179028bbf0b8b2"
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
