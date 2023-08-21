class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.32.tar.gz"
  sha256 "07b168491fa103a57231483a80f8e03545d0c957672e96b73d4eb9c8c8c43930"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "ed7f7b449b42f49d7e2b18372dd9aea4de47fc800dc9433bc80014feb11b5f4e"
    sha256 arm64_monterey: "0e9d3904135b0e40e4819901bbb22d5b700de1779ae8db2fd5bdd9d4364a13c8"
    sha256 arm64_big_sur:  "f5298c9467e596907908af2a874f8a4c31d99587407ef89116d2ed0cbcb34b32"
    sha256 ventura:        "0288f6a7977ac822f00c8675f65f0c02f613790912d047c3d57b2457b5811632"
    sha256 monterey:       "1e95b72c5a446311d7b962c63b415fb17680dcdd5d99acc968f4071b48f5fdbe"
    sha256 big_sur:        "21a6ce060f38728124bb3dcb22d632ecf0eaf2b3c909b88dcf5c37baefda13e0"
    sha256 x86_64_linux:   "93333c25d0c6328d452744d3bfb1b9d5a5a1888d1669f9870d695f0406b879f7"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
