class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.3.tar.gz"
  sha256 "b960c0d215927be1d02c176e1b189321856030226c91f840284886b727d3a3ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a9ab2f87ad2f3eebbd59be6af9a2a712942c73aeb974e6b7887378134ca7bc3" => :el_capitan
    sha256 "10c38d17815ce54307d66dca10ba4941cb177e5cc28a12b242bd89c922146b0c" => :yosemite
    sha256 "3c1ca846a173a24f4cb5ac82cef839d751087997cf306f6a0a7c697d9fe3dbd4" => :mavericks
    sha256 "d49d123d14395a089923427c6dfaad3048a7cd277c88a704584e9c3f22d3c783" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"slurm", "-h"
  end
end
