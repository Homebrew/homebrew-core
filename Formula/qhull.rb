class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2015-src-7.2.0.tgz"
  version "2015.2"
  sha256 "78b010925c3b577adc3d58278787d7df08f7c8fb02c3490e375eab91bb58a436"

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
