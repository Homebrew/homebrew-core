class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2020-src-8.0.0.tgz"
  version "2020.1"
  sha256 "1ac92a5538f61e297c72aebe4d4ffd731ceb3e6045d6d15faf1c212713798df4"
  license "Qhull"
  head "https://github.com/qhull/qhull.git"

  livecheck do
    url :head
    regex(/^v?(\d{4}(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "4184d2e81f587b29b20f1b116862c2311dbcb46c37e0067bb9a670cf30dedbf2" => :big_sur
    sha256 "70ad8528bfc11ba315d21927b68d48edc0500ec3d2aa5d671ffafaded1311573" => :arm64_big_sur
    sha256 "45f8b6efc0a77e4fd613ef527d6c55545908f860106d4355bd753ad07a934bd1" => :catalina
    sha256 "61a2fab7f2854401bdffe54b889a1e2b9d90f6a11e52aba80688875b8f7d08a5" => :mojave
    sha256 "36e0e4a621e0c89746584562634768ccb93e71fc500230133620db030b1cc05a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    input = shell_output(bin/"rbox c D2")
    output = pipe_output("#{bin}/qconvex s n 2>&1", input, 0)
    assert_match "Number of facets: 4", output
  end
end
