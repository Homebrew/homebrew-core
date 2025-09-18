class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.57/yosys.tar.gz"
  sha256 "38e4edecd91006b45cadd33daa38f39c42ab625fe7a58cbfd8ab023d4a87bc4d"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "1090fa2a9c14ac77e79f849ac9d2537d74bbe45538ab1f5c302065e79c7a0cd7"
    sha256 arm64_sequoia: "1a9f552722886c0c8787f1cdc4244e1ea7cd0af1a61aecab0dca0ad13cd2c171"
    sha256 arm64_sonoma:  "7c145f3d2e84e8a8606203e86543011819d1765dcd826c619e06a953c708a4ac"
    sha256 arm64_ventura: "4442c9393c11562e97f1719cfd870270b3509b2a26f7cb81bc80f3d70f1ad761"
    sha256 sonoma:        "021b053be2b6e2cc3cf363b57283e482821aefac61d5ffca266f98846ca8d8d4"
    sha256 ventura:       "359b23af23da7618bccbfa2d6452b5bef1cfdf4862c6c4537a68e103ad04b5b9"
    sha256 arm64_linux:   "ffba63126af41c5a37f1a75405722c0809b0252895b101d0333af4d361627b10"
    sha256 x86_64_linux:  "e82e71b8bc232e714cfc53cfe98ca11057eac6c93337a8f598740fbd69235e81"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi", since: :catalina
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
