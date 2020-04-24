class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v1.0.2",
      :revision => "917b0a7b46954e9be36cbc430a1727bb093234bb"
  revision 1

  bottle do
    cellar :any
    sha256 "6aa29d41bb68563cc0ec2663fa8b8c748e0bd3b6be6605d2e0f86bec0d1178e0" => :catalina
    sha256 "e2f717e66054ee2219ad3114ba0b87abf438205efeb5c97559cf418f68938aa2" => :mojave
    sha256 "44a122a445528ced68ae2c2963c7b89e4835a83558ebc9191b72bedeedaa0270" => :high_sierra
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
