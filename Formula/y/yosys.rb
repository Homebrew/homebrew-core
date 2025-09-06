class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.57/yosys.tar.gz"
  sha256 "38e4edecd91006b45cadd33daa38f39c42ab625fe7a58cbfd8ab023d4a87bc4d"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "33f7b02c67d9f1cfe91f13702d3404a5d9b6f55bed1c2fddb51bccd87bac5af9"
    sha256 arm64_sonoma:  "c19a16733b085d014f30a259db52bacf1344d5cbd274e918e0febdd0da8427af"
    sha256 arm64_ventura: "4b5329d0ee1c92bc16aeea600b566b9586e4e37f214eeb252916629052aab3fa"
    sha256 sonoma:        "d1485783574a4736647e675f6c59ea4bf0fa0816377fae64a2093260491b34bf"
    sha256 ventura:       "32818da322b5a9fb9e220f8a71f79fb5d942abe93b1c75c92ed343ba2cc98be7"
    sha256 arm64_linux:   "f6bbc6913e93dcb3446c6238348fbf52b35f2ee0169b923feb276b9f85f22186"
    sha256 x86_64_linux:  "e781387b0b2c8ae49077ce07d0d12cbab593c58e9d5465f7bf555609926ff73f"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtommath"
  end

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
