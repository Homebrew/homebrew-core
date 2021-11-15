class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.3.tar.gz"
  sha256 "b960c0d215927be1d02c176e1b189321856030226c91f840284886b727d3a3ac"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d72123c0ef2aeb40409fd7b8b2d38b426e0bef674019128ee7efbce79f719d00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0568e6cdfc383e2ad89668439afbae2a0f9bf7f7061e3b721dc16cb4fbecc77a"
    sha256 cellar: :any_skip_relocation, monterey:       "8a18a5aa0994495beb9bc8aec6c39a4c6ca1a01b49ad18742495e48ac3e6c0e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0ac2178976e42aafd42e37833725b82ad775d8ac170d91f1ee88e6df556c8cf"
    sha256 cellar: :any_skip_relocation, catalina:       "7c177b599a6612e1b6e7f68dfe44dc7f23b71788548eab184b33d03d5a5d8da8"
    sha256 cellar: :any_skip_relocation, mojave:         "1877e60b9696aca27dce408c18113108ae08611914a120c9fc52a59db9eec99a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "97f41cff81bbc7ee1d0f9599e7b697d97834343a7a867497b5920246f836a327"
    sha256 cellar: :any_skip_relocation, sierra:         "03f2d26fda7d44d9853f4e24ca0cd28b7096ec174ea6de731234bdb7d7742f88"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f77b8d2eb56422a448af47cab61f2e9b48d7d82439fa44ecd4dd19cf18ff83f8"
    sha256 cellar: :any_skip_relocation, yosemite:       "ec4091e007334ba76cccb21d4d9dd6cc229d38193de110c38aee969969ccf959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e57437b452f76cdf1244c14702635545a684916e1b0891fc724a47735c5e7bf"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"slurm", "-h"
  end
end
