class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2019-src-7.3.2.tgz"
  version "2019.1"
  sha256 "2b7990558c363076261564f61b74db4d0d73b71869755108a469038c07dc43fb"

  bottle do
    cellar :any
    sha256 "2914810492c9ef6f46606237d8ab3adc84b4cdb5edfdab722dfa4adf58864504" => :catalina
    sha256 "fcee31c1350555f924e27fc7868c4244fe9e6f3be67dc9a91426c85f27e65306" => :mojave
    sha256 "9eab455f07e6bc666960235f23919cce155bf630a689cafdf346083dc88925df" => :high_sierra
  end

  depends_on "cmake" => :build

  # fixes build on case-insensitive filesystems
  # see https://github.com/qhull/qhull/issues/48
  patch do
    url "https://github.com/qhull/qhull/commit/6052739c827bff64de3f05343e45fd080909759c.patch?full_index=1"
    sha256 "ed97d5920ad9c09e028a26da1f0e8d9d313f3e757d52c14ea562827d6c865804"
  end

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
