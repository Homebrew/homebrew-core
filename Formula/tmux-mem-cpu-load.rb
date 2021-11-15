class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.5.1.tar.gz"
  sha256 "6b62197ba755eec775b3f494db617b239b5e9d79945e165a3c8bba3b9092d0d1"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b4efd685db52034ff83750c201420572d4d9630f407131244edca9510d0bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4a7b18971b2e0e9eeff0a08cc6279123274e0297cc5b713456b2fbfb535630a"
    sha256 cellar: :any_skip_relocation, monterey:       "1d701d57c8981e9248304a33be04df644a74cd8d4bb1ec4c3d7e105cceec3185"
    sha256 cellar: :any_skip_relocation, big_sur:        "026c86f3e7a4d2bc843228e82589f1c3dbd722f2bdddd04f04984ef726343bf9"
    sha256 cellar: :any_skip_relocation, catalina:       "03918a0cdaa2a2f270632b5bf91a778a9c393efe0d70f422142246489a5a320b"
    sha256 cellar: :any_skip_relocation, mojave:         "27f3e497ef98401b7e5212e2f3ed4a255b37fd6f404b7f77c6e93a9f49201d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15d09da7dc4d4a50735f9e37006a754279140aa366781d5915c0774e2a7e398"
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
