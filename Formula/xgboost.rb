class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.1",
      revision: "a78d0d41101b3b7ad10880f38498751166ae2eb3"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "56c88f363161fcf695d5e3fa235256ef22465d405d401aa6d4322c0b79bfb02e" => :big_sur
    sha256 "5c14b128cbe2c89a944df2cfb50543d9ea6d5890ab4bc3c834d83d42c2485800" => :catalina
    sha256 "6a91a20f6d716f5a85e7ffd1ce5e6d957b43a414dde7a38fc4d735350dd1556b" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
