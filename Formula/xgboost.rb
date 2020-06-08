class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v1.1.1",
      :revision => "34408a7fdcebc0e32142ed2f52156ea65d813400"

  bottle do
    cellar :any
    sha256 "7641d5ec78f41c5970703a62d6a06cf75ca8859b98e0d6820119672c4b985942" => :catalina
    sha256 "50e6661f93dc3d8c87801b61e22f1de87fed8e50c92fc724c920035d7bd6724e" => :mojave
    sha256 "fe443009e2572f31ab0d5f0e7138d3f62fbf24f148e12cc7558ae012cf72a242" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

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
      cp "../binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
