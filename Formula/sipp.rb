class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.io/"
  url "https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz"
  sha256 "6a560e83aff982f331ddbcadfb3bd530c5896cd5b757dd6eb682133cc860ecb1"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c6c78faec61804f8915e972c5859a260199eecc30a5784478d8622a04a4a8bf0"
    sha256 cellar: :any,                 arm64_monterey: "a0bdbddf697ed205e64e6368b8d1b4e28ca308b7dc719b4dfd8d597f682b27b7"
    sha256 cellar: :any,                 arm64_big_sur:  "a84e6a723778f8c12305dc3c15086f09c1e0992b1bd441dd5d038509a5f5eb74"
    sha256 cellar: :any,                 ventura:        "450c27ef4eddf1bc1643da0d7bd5f52e011ee4c8c6cd0e469f95e707534afad8"
    sha256 cellar: :any,                 monterey:       "2708ed011c5dd412637ce8bb66c3e70f075a5e4de5f45ff7a6a3cc8d2a45600d"
    sha256 cellar: :any,                 big_sur:        "7914798957a251d8188a7323af5cb4b4211c8c42c4fd66551c8542846928d729"
    sha256 cellar: :any,                 catalina:       "06f99107de6ee72ffacd9815b519fba256df93d99c04770eb75f2ba89159c648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d86bacc124426180ed34773ad4618a186af52b3ab46b7dc42330058bc8866d17"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    system "cmake", ".", *std_cmake_args, "-DUSE_PCAP=1", "-DUSE_SSL=1"
    system "make", "install"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
