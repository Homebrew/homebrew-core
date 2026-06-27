class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/refs/tags/v3.8.3.tar.gz"
  sha256 "ea7a24802d6d1223831f749e68ef29c07c9c5e45dff570022f844ce37eb56c85"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ee7e22ff8c7539018ef84144e2c683350f114707666630dd946dadf3da4c7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd7d96a1211a5de4dfc57badf33461e7a8698c4b71fb33c7921332b4e4e34c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d3aab094e482e7a174da872b01d3822824618cb7042c6ebdc5853f038972f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb276f76f9c75fd5e62cf6221d503a33df4acdbb9ea5e539df6633c9ba945914"
    sha256 cellar: :any,                 arm64_linux:   "712e6d4d23f122d655e4798aa86239943610b9fed48680e27811b73549d12c2b"
    sha256 cellar: :any,                 x86_64_linux:  "398e414afd2bfcf6bdf76d1d9e6616f4a12c2582883bace347ecb870d7763136"
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
