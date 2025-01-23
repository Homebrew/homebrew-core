class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "3fc373233f47c5cefd540a192415cf37f0135dc0d05530e63ee34eb927e1f1e0"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "980cf3f537ba72c0d7fca497c03e6562c69499f4bcf5413f737b6da7abc016b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef9e0faf28a1f984fe8efffe725a23d81a59b259a84a9b180293398ee07d0a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d91396e2c6eb3e94d8343f6083ba061ed81459a3c413f4d991a70d038719f0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ad4f582f859b79611a44bd83a7d13d70920fbb8cb4c7eafc01f974fbe38c4ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "c57514a7fea2d7f83c5e237b015f312cfa601e516e13acbd4794e8f7a5f6dc0d"
    sha256 cellar: :any_skip_relocation, ventura:        "1b0b301683d793030f7a12f17238e14d40a2ed05cfedb9722af6ad3d2e07e660"
    sha256 cellar: :any_skip_relocation, monterey:       "134c4b3ded75c406a60add39d8674483bd5863dbeaff86af22ee4404744e067d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a4547c45737940eaec35865376d01fd67d7087475926593f71637333b1d0a5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"tmux-mem-cpu-load"
  end
end
