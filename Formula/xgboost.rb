class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.3",
      revision: "000292ce6d99ed658f6f9aebabc6e9b330696e7e"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "42a3ec388bf05959fbd05c6b918cad2fba99a2a1812e9916e7ae9cd92dfb7af8" => :big_sur
    sha256 "b5365cde699802720656bfa80f19f09f49825fd0f3156a7ce6c5a4cd5ccaf84d" => :arm64_big_sur
    sha256 "b27e1a0394848b9840c09198bda4cae9bc57314ce833082f701336c434bbd4c8" => :catalina
    sha256 "2a65f86dc8a2d9576c64a94f2296c481880482739d80dca988abf6a96e1ccf34" => :mojave
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
