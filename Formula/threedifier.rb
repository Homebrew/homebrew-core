class Threedifier < Formula
  desc "Takes 2D GIS datasets and 3dfies them"
  homepage "https://github.com/Homebrew/homebrew-core"
  url "https://github.com/tudelft3d/3dfier/archive/v1.0.3.tar.gz"
  sha256 "0216cdb4bbad4f6ec8a3867742129db2b365a9f92a6cb6744bb6266be4f466f5"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gdal"
  depends_on "liblas"
  depends_on "yaml-cpp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "{bin}/3dfier", "--version"
  end
end
