class Yajl < Formula
  desc "Yet Another JSON Library"
  homepage "https://lloyd.github.io/yajl/"
  url "https://github.com/lloyd/yajl/archive/2.1.0.tar.gz"
  sha256 "3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a"

  bottle do
    cellar :any
    rebuild 4
    sha256 "65975afbeddbbd919282c04e53fccda191501eb4fa8992a2b4ab1b2be2e10151" => :catalina
    sha256 "ab562be70a8ff64861d52b170585f52af91a275e6b5974241eaabd0997b990f2" => :mojave
    sha256 "3213f11462b3c60a33209c4f5d36c96caf1a9409103012ffb427dd51770ac120" => :high_sierra
    sha256 "1f97e0bbc6680ad4735f0c7ecac20ec87531456c3ab1c93c480c5c5a93a33e1c" => :sierra
    sha256 "5cfd83bfdbd7c92402f1cecc6b66788e6db0c195880a40263365d8130e47db2f" => :el_capitan
    sha256 "600fec6352ac23a66795cce22cb0a555df43eb464c87693299cb4fc2a1307833" => :yosemite
    sha256 "d44363e381f2f353387374167520ed166f3c0c756887dab6e015961bd9ba5ff3" => :mavericks
  end

  # Configure uses cmake internally
  depends_on "cmake" => :build

  def install
    ENV.deparallelize

    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (include/"yajl").install Dir["src/api/*.h"]
  end

  test do
    output = pipe_output("#{bin}/json_verify", "[0,1,2,3]").strip
    assert_equal "JSON is valid", output
  end
end
