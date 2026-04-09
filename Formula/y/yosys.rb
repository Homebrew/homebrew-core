class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.64/yosys.tar.gz"
  sha256 "1faf20509c21039b6e88136677cc2fcb296e2023dda8d89bc8215367c37f9ca7"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f2df7bf92ca919d4ef86ad21d8729186fcb23326e74a26da42b68377f70dc521"
    sha256 arm64_sequoia: "0537a9df81fac16c308c59dabca8f8a7239769d50f7af837268018c652fdf47e"
    sha256 arm64_sonoma:  "507dc763c0243dc4927bba3ff7a8a057d12b0c3130066794c3940718eb78b728"
    sha256 sonoma:        "5cadac882c32ae74d42164ceba83feb7fc89e67468eae620fceb56674f52ed0e"
    sha256 arm64_linux:   "5d382ac97f625de4919059e3bc804ac14f4f91898937060074b0995b8e8634db"
    sha256 x86_64_linux:  "20525045aff829f8930b96f8e08a7840ca79e711f7a84a19cf878801c01e0435"
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
