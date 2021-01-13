class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.2",
      revision: "3e343159efaab1ec18ceab3a0425e5de6b50075b"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "83aa8c4de0377475ea7d59cc1b86a427614ab2d45e5947a4a0ef9725a10d9e62" => :big_sur
    sha256 "e6874cd16fe1e9caf0d27b75bdf595f640b79a99da0f667846d8a485eb847b95" => :arm64_big_sur
    sha256 "9492eec6728f04259ee801f6f09a3f420ba626ba02d949ca3b62aeb11429d7d3" => :catalina
    sha256 "6487891dc5aa7d5dd6748b77d6994f641e298f57aabcd33e1d5be1e4d9a1ebdf" => :mojave
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
