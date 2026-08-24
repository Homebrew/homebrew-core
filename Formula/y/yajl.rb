class Yajl < Formula
  desc "Yet Another JSON Library"
  homepage "https://lloyd.github.io/yajl/"
  url "https://github.com/lloyd/yajl/archive/refs/tags/2.1.0.tar.gz"
  sha256 "3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47d4da4cccfb876590a168cfe8933efbef1ebf20f34b6e77ccbca9fa3781ffd7"
    sha256 cellar: :any, arm64_sequoia: "5e2fdde552817d6ad12ab167fd2abc24909be440c019ffe1de58d96d1db77789"
    sha256 cellar: :any, arm64_sonoma:  "b732da866e20da83003aa303aacdb628d83682c716e06d9ac4d3da9cdf06a3f3"
    sha256 cellar: :any, sonoma:        "cfc578e373be609adcc6d3e66fcc062c2210113fd0a03bfb258921d2f6f227a5"
    sha256 cellar: :any, arm64_linux:   "43391d9a81434dab4d9d438c1154e1af27f1d13b03473898db15037bee6d0a1e"
    sha256 cellar: :any, x86_64_linux:  "d859ff07b32164d87a7545f5b9a0a44cd4dd3ef9ad74388925061a1f5ff011f6"
  end

  depends_on "cmake" => :build

  # Upstream is unmaintained so we use Debian patches to fix CVEs and other
  # issues while formula is still used by non-deprecated dependents.
  patch do
    url "https://deb.debian.org/debian/pool/main/y/yajl/yajl_2.1.0-6.debian.tar.xz"
    sha256 "462fb384bef46c7252001c609dabc126624a1b71e9597cc16827d25a0226453f"
    type :unofficial
    apply "patches/dynamically-link-tools.patch",
          "patches/CVE-2017-16516.patch",
          "patches/CVE-2022-24795.patch",
          "patches/CVE-2023-33460.patch",
          "patches/6fe59ca50dfd65bdb3d1c87a27245b2dd1a072f9.patch" # cmake 4
  end

  def install
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (include/"yajl").install Dir["src/api/*.h"]
  end

  test do
    output = pipe_output("#{bin}/json_verify", "[0,1,2,3]").strip
    assert_equal "JSON is valid", output
  end
end
