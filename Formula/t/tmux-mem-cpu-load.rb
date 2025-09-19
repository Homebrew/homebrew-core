class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "c433e396050a821f915f3fd1e7d932b46204def8d59a46fce4f486b1b4ebef2e"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c2ae55cb2ffbc4cfeff943ea057a2b6e98c444c3b7a851bc25adc4969679a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b9704023cfa01f2a66fd26ba6619fee06b10e37fe37d50520c60c703b71b082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a40e5242c4235deeb4203110ee580afa44e2071595717c8565c744a40835135a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49ae4c6d2621caa0711fdc119a045f6e13be528da201e5df678ebbf2ce16bd7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c300b2c57ff480f97b6013a9627c3b74532e8983829b1512f84a8ca5604107"
    sha256 cellar: :any_skip_relocation, ventura:       "e86000baff73acb680106265ee4ff32c469bc060097904401f274dd2f5aa6e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91113c2894a4d31d72697bbf71047a6318b938c67d5750386bf333d0140e2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dcb9393b62f525dcadb1e1c463e3f0e34d9553038e8089db2c82548f180e56f"
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
