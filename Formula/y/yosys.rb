class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.55/yosys.tar.gz"
  sha256 "7dbbabf35a08732104768a43f8143e0c7714b01a7fe978c044cf0df2f8fe961c"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "4cf4a8bb273915b977b32eddc82f1fdf6a759c16ed7676cb950631e43c0ec3fe"
    sha256 arm64_sonoma:  "838f0b6a2a67369a81ba30cc2e68480713b31cb80adef1ddf788584904d82be4"
    sha256 arm64_ventura: "efb960a6598679674412ce02fdc73b1f28df8b041ac8821a7a5713570679983b"
    sha256 sonoma:        "e89c0cc5b6a246f768a91984ca3ccf51dafd395b2dfe0ef17d2696ec446caed8"
    sha256 ventura:       "6015c3bdf680b13beca9fcf7be29fb3174083eadc08902f23f9fe8babdcec8e3"
    sha256 arm64_linux:   "382508967502335f4c828a6582b6629a5c547b9e94fec05d9fb766ca9ee6bb62"
    sha256 x86_64_linux:  "085547531daf55e93cd910a4335deb289de03dc1c362a1f9ba9ddda4f6b8d302"
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
