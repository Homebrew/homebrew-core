class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v0.90",
      :revision => "515f5f5c4779ff5361dcd796e22d55937e1048ea"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DUSE_OPENMP=0", ".."
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
