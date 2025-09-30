# This fork contains macOS patches.
# Original project: https://github.com/roysjosh/xbee-comm

class XbeeComm < Formula
  desc "XBee communication libraries and utilities"
  homepage "https://github.com/guyzmo/xbee-comm"
  url "https://github.com/guyzmo/xbee-comm/archive/refs/tags/v1.5.tar.gz"
  sha256 "c474d22feae5d9c05b3ec167b839c8fded512587da0f020ca682d60db174f24a"
  license "GPL-3.0-or-later"
  head "https://github.com/guyzmo/xbee-comm.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "49a7355172da267afee94bb366bcb090a0473aab8784b0b26b24b21f6b0b9c48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3a9eedfd657cad6df2ac1df6c320df225e7b9c14add897b1044fecd21d161aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b50fa055f4f542eab3a06ef487bf7eab058d592c1b27eec56344e09e17bf9093"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19861ec3a7e655a1371000d05898e0b7d1f169139d9e70dc0fc42943a685514f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01389dc2aeb100a4114568be24c53b755633ef965fd9098564d439902790d3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4dda0f81a92b04ac242a71d3b233da85abdcc767b8c5ec956e3285565eef994"
    sha256 cellar: :any_skip_relocation, sonoma:         "f38c951e887ac6f38bafdd455fe95607aba4add5ffbfe2c0b722d5060408272e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad8ec612f36bcbac63cd1aa11f43880f7d98357246d96798e773849359638066"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2839fdb06e6b425afc91ae417293ac500893f8963b88acb35153034d3e1ee4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d163cd9e888a337b0bc39bc3af871a0ed0b8efadb75933e4a4273fbccdfd90d"
    sha256 cellar: :any_skip_relocation, catalina:       "4c4eb5e75f59ac2527ec72d41e5e11ae156243278b7c92186fdccec62435a783"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fc58db4ba36c437b60007679bc67881898167c5f2fb490fd1c71c9707b1338c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf23d16b599dc5427dd3552004d307bacd82b77b89ac2bd0a018bf1f986fc720"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "-a", "-c"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
