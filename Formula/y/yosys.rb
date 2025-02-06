class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.49/yosys.tar.gz"
  sha256 "8fcc393ce7c296ffe8784b22b0760040fb5148e37de33926eb9ad81d5046ae4d"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "5cd4c36f43f301d86946a7166be5f949f86643e5e3853d65960cd26696031a62"
    sha256 arm64_sonoma:  "1b7234c96a0493adba063ef5d06b2f4dff0cb13fc1ba1af097aaf1ec513b0b18"
    sha256 arm64_ventura: "2a78308346efed923cfd59d17a57a5e0b2744b92ee2e5ac9d12719e6b10bddca"
    sha256 sonoma:        "167b5cc677f3c7eaf5d6e83ce500f8281efc8c9b81509cbe490dc7c13ad0124b"
    sha256 ventura:       "822fbb8cdd55ecf1937295d2ddd962bfe404429e627887e495cd59fff40400ad"
    sha256 x86_64_linux:  "450c4cd9455c16e7339eedbc322afffd24755b3469fc2565f29fc28be0f8d76f"
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
