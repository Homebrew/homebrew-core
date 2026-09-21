class Yajl < Formula
  desc "Yet Another JSON Library"
  homepage "https://lloyd.github.io/yajl/"
  url "https://github.com/lloyd/yajl/archive/refs/tags/2.1.0.tar.gz"
  sha256 "3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a"
  license "ISC"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "deec3842a98f0f3dddeb406eacfc8355c1822179f6a6e7af0c310ef456bdd2b0"
    sha256 cellar: :any, arm64_tahoe:       "5d1b2c74b5de11ed9ec440b7d03090c53cafe949c59d2d5405bec9f93317cf87"
    sha256 cellar: :any, arm64_sequoia:     "0aa351ee73c6d3c5aa03accfbe29c7b338948011bca27a16aaa0249477c83b98"
    sha256 cellar: :any, arm64_linux:       "6cd5d794e58376d88f0e12f6b3766bd846c2756a9177fac5136546808ec26bc1"
    sha256 cellar: :any, x86_64_linux:      "952b6eec73693e1433b9c1eff9d14645098e8c6f4f384b8bd8963bc13a116166"
  end

  depends_on "cmake" => :build

  # Upstream is unmaintained so we use Debian patches to fix CVEs and other
  # issues while formula is still used by non-deprecated dependents.
  patch do
    url "https://deb.debian.org/debian/pool/main/y/yajl/yajl_2.1.0-7.debian.tar.xz"
    mirror "https://snapshot.debian.org/archive/debian/20260901T022952Z/pool/main/y/yajl/yajl_2.1.0-7.debian.tar.xz"
    sha256 "9196bd56b2a806d1b9794892dc47e994e5d76feee7a8208ee11d541b7421be78"
    type :unofficial
    apply "patches/dynamically-link-tools.patch",
          "patches/CVE-2017-16516.patch",
          "patches/CVE-2022-24795.patch",
          "patches/CVE-2023-33460.patch",
          "patches/6fe59ca50dfd65bdb3d1c87a27245b2dd1a072f9.patch", # cmake 4
          "patches/non-gcc-visibility-check.patch"
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
