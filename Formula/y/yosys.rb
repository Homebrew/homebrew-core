class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.61/yosys.tar.gz"
  sha256 "5a2871694596a3da8babc18d036f942eea0a379bce5471a16a12b2547057cc9f"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "191f69e2bc87266466693eb6d4d969e7d85ef8a0929eb5edec87af7b5a2da3c0"
    sha256 arm64_sequoia: "d33c127cd2432f00599a14a1e47221f5f72989b0e1c417b8d482570a6a54b506"
    sha256 arm64_sonoma:  "54c5107441562e82f26c4a482dab3282e6389ff980987907ef540d5b69e39f44"
    sha256 sonoma:        "e1662b8452800abdaffe3482235ef12330b43bc9ebd47790f213e3bdb5e631c3"
    sha256 arm64_linux:   "b3c3c5b7ef0ee602cb172cc76f4b85d4542b38b779d74039245dcd6c4d092c00"
    sha256 x86_64_linux:  "9120d26a68bf404db6fb5c72cc338d84aa4475b097f480bbe565df3e1acb1792"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"
  uses_from_macos "zlib"

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
