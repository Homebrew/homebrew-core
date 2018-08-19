class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2015-src-7.2.0.tgz"
  version "2015.2"
  sha256 "78b010925c3b577adc3d58278787d7df08f7c8fb02c3490e375eab91bb58a436"

  bottle do
    cellar :any
    sha256 "33b41bad4871bd781b91ca4c418a1b5c94dc29f676288bd8f41b5ae8c302b329" => :mojave
    sha256 "91d7e43f955fb4d9513d588e4f56a6b6c6101e9a9e0f6ed73c63a045bd4b8c25" => :high_sierra
    sha256 "2b0192507bef8e077cae894ee59a2a25b490170cc1be64413caa1ac6e48da86d" => :sierra
    sha256 "98d3967e46833ff3278b6815b638b5c4b049bb621543b9015124fef83276ab01" => :el_capitan
    sha256 "00fb087ce5f3d674d22959ea820b4e3605b02ea31694d4f00d2044bc54ca3c02" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    input = Utils.popen_read(bin/"rbox", "c", "D2")
    output = pipe_output("#{bin}/qconvex s n 2>&1", input, 0)
    assert_match "Number of facets: 4", output
  end
end
