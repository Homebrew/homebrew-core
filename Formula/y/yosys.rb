class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  # pull from git tag to get submodules
  url "https://github.com/YosysHQ/yosys.git",
      tag:      "0.46",
      revision: "e97731b9dda91fa5fa53ed87df7c34163ba59a41"
  license "ISC"
  revision 1
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "2a04f4b241f947cc6bb50b8a114cc2db3c055954804ef9cb29bd9da389955577"
    sha256 arm64_sonoma:  "2e3f002dce8463250271d2336fe6e4e2baf67d82667724d4eeab13f7c84668f9"
    sha256 arm64_ventura: "98f1878f83244b947945b7c3ab47cede4b41f08c822dc51329206e28129136f7"
    sha256 sonoma:        "6ee0575c1c3d11a57d54f8342e6c225f6df7fc69eb5e8d840cfe59c07af91a64"
    sha256 ventura:       "7eb3b7f050b2ae09c3c5c229f4f7c55995d52786cf84ea18ba759fcf932fbc3e"
    sha256 x86_64_linux:  "62b4b41163de8ee55b179fa2262e163c949848263236e4ec175cca2b83c51e5c"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
