class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.3.tar.gz"
  sha256 "b960c0d215927be1d02c176e1b189321856030226c91f840284886b727d3a3ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "03f2d26fda7d44d9853f4e24ca0cd28b7096ec174ea6de731234bdb7d7742f88" => :sierra
    sha256 "f77b8d2eb56422a448af47cab61f2e9b48d7d82439fa44ecd4dd19cf18ff83f8" => :el_capitan
    sha256 "ec4091e007334ba76cccb21d4d9dd6cc229d38193de110c38aee969969ccf959" => :yosemite
    sha256 "737bb85b1e76c2a577e515857ae01d7eed5b64f0ea514bae0534f1360cc53566" => :mavericks
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
