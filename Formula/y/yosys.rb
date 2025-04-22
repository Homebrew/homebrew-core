class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.52/yosys.tar.gz"
  sha256 "cf741e7971ba7701b71f2aff18b202de182d55e7803803c16b972dda9b77c490"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "035089ad6dbb9e733c5736de6ca6dae3e3229178b8347ec0bc0864691786414a"
    sha256 arm64_sonoma:  "b8956b5a1ab465868f62d77b5f8201fb5df95d0339ef9ce24ec89b0f305dd801"
    sha256 arm64_ventura: "01815d612d3267e55e37271e677216f47d6c3d0bf2f719235193712c7c64fa62"
    sha256 sonoma:        "02e678672c77ffe8f1197408ad611f4f81ba91b7b4f24ed1f89d617501a13fec"
    sha256 ventura:       "12ef101afeed79b7dfc77edfa3fdee5391c5d6edae4d4a3452751d374cc87fb0"
    sha256 arm64_linux:   "23b1cd7b8ef9127fc23de2f87e52f9eaf82bb8031b2872041c21201359096c25"
    sha256 x86_64_linux:  "d34c2cdfec94b6e871f043496624886642f81cadd52fae530188e72b9a6da492"
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
