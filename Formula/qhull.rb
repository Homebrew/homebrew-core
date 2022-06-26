class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2020-src-8.0.2.tgz"
  version "2020.2"
  sha256 "b5c2d7eb833278881b952c8a52d20179eab87766b00b865000469a45c1838b7e"
  license "Qhull"
  head "https://github.com/qhull/qhull.git", branch: "master"

  # It's necessary to match the version from the link text, as the filename
  # only contains the year (`2020`), not a full version like `2020.2`.
  livecheck do
    url "http://www.qhull.org/download/"
    regex(/href=.*?qhull[._-][^"' >]+?[._-]src[^>]*?\.t[^>]+?>[^<]*Qhull v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "149d647d68ab1386f21996abde29a0c158cb11d740318c8c61112e77e3419170"
    sha256 cellar: :any,                 arm64_big_sur:  "d54263b22f2c4effc10ab2dbab54ec0b7f2592d07cdad43c20ddfffff149aad0"
    sha256 cellar: :any,                 monterey:       "91c5c29003c0f86c85b4e597b2aae623012517c8cf1696686a6d3f97b0c507f3"
    sha256 cellar: :any,                 big_sur:        "1c0b6ed4613b8319859b7c0c15b174bb1e89178c79e060ccc400220beb079d46"
    sha256 cellar: :any,                 catalina:       "b48c342482e1e50857c444f8eb39f71c36a522a9f0692bd479b93d2088672d2f"
    sha256 cellar: :any,                 mojave:         "6bec66662d9b4d1942a959505442790cfafd482660a2c8785a45175714fe1ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97152aca48ede908990b7d3935bf3305b559833074bb4c92fc6fdab68f95fd23"
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
