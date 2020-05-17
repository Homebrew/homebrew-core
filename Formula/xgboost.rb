class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v1.1.0",
      :revision => "f5d4fddafec7ff0e908b776e0cebf554df6b89d0"

  bottle do
    cellar :any
    sha256 "2da3c97326af103ab719531f3723df91970e0cfe930ba4c5a45f0377c5f7fa20" => :catalina
    sha256 "a9b1ee935c9aebba565add5b01290132588be5330df2b32ed9072909039d77a3" => :mojave
    sha256 "ebf1e65a2f69f4dc3bb0a137d304095aa6ed6774a087da4afde563a8cc19ac19" => :high_sierra
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
