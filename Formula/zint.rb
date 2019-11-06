class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.6.6/zint-2.6.6.tar.gz"
  sha256 "648df79cd48b45e5af75b72385d1a5a740f178178d988fed3c37aa7e59bef541"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "e207ba62ade405ae00c0c04fee93c4a03df6e2af58d5792cae0eb8fb3950f860" => :catalina
    sha256 "96bba9c12fe783afe88b9fcce020829468c09700efae66e2ce5916e8fc05aac2" => :mojave
    sha256 "9dd6414fe915b0821fd3bd7b1f054bce874a40ce13dfe7cc06c95ef2e6dc9bb4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
