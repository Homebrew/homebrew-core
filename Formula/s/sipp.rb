class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.5",
      revision: "74b4ef48f8a233ba305ea26abf8826a9422801aa"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c14fdd8ba2eb45885315842678991f42c734cb1b3d9963bbbe390e07aec32bf"
    sha256 cellar: :any,                 arm64_sequoia: "a2942b53371902fd437dd9458831a0a497135a7499206e790b52e483a89ba557"
    sha256 cellar: :any,                 arm64_sonoma:  "608fcb0e1163938683a24673489d17e14d7b13a1b6767fce37dd42747964adfd"
    sha256 cellar: :any,                 arm64_ventura: "1a11504a9913aff93e03b8b8cc1d153f364710992b51132bcdcb0402b57be35c"
    sha256 cellar: :any,                 sonoma:        "9e64cf797e33a2e8c3416e06c4e9aa2afc013d4bdf77577d10f3134603b7bace"
    sha256 cellar: :any,                 ventura:       "145387c8e8ee0545177ca3c42a496a51a43ba08b3ab74425d3a1371fcf7e2a8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a493972c8f938798453004d49e5a55c10809c57b4e391299a2b0ac22c9a50b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d41b7f47fd3c19bbb42f819abdec06dae932d1268e1c1ff9292894a9da4de6"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
