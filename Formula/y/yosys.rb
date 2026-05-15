class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.65/yosys.tar.gz"
  sha256 "ab6492e7c19c4b51f25eae3a1ff7849be15c9ede2c01cd38269855be075bb33b"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "d2dad8d3d975bc895d7cd8a0d1a010d818e75161127d81c039705e4784ea3c4d"
    sha256 arm64_sequoia: "a88df17bcf90445910f414273a6a69a66e833eaf00b2392764bb852d27f736a6"
    sha256 arm64_sonoma:  "4af2cfb7f436a87d334022012a6d0f95bf721594ac1f9ac9ca6e2f631b3847f6"
    sha256 sonoma:        "fdbb063bbe41bdd67052a5a97ee8b7c63716c3a4a389697efda2ac9a59a2b44c"
    sha256 arm64_linux:   "74e310be4ce58a1b5b6b63f3a9b7fb0c27596a55c201d21792e6b1111830444a"
    sha256 x86_64_linux:  "70840673fbb5a4498cca85b64f820121b2f3f3f691194d8753da13c455d3789d"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
