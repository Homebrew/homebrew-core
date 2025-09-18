class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/mct/tcptraceroute.git", branch: "master"

  stable do
    url "https://github.com/mct/tcptraceroute/archive/refs/tags/tcptraceroute-1.5beta7.tar.gz"
    sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

    # Call `pcap_lib_version()` rather than access `pcap_version` directly
    # upstream issue: https://github.com/mct/tcptraceroute/issues/5
    patch do
      url "https://github.com/mct/tcptraceroute/commit/3772409867b3c5591c50d69f0abacf780c3a555f.patch?full_index=1"
      sha256 "c08e013eb01375e5ebf891773648a0893ccba32932a667eed00a6cee2ccf182e"
    end
  end

  # This regex is open-ended because the newest version is a beta version and
  # we need to match these versions until there's a new stable release.
  livecheck do
    url :stable
    regex(/^(?:tcptraceroute[._-])?v?(\d+(?:\.\d+)+.*)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "3487da59a7faa8fc676d540fd1b5f310b62b845250e1916db5dfbb192a37b76f"
    sha256 cellar: :any,                 arm64_sequoia:  "07b6c54371373c5e7e23fba003ca0177fc103f0b9c84c22a4fc1d718fd96bf00"
    sha256 cellar: :any,                 arm64_sonoma:   "3fc2b91a08dc814aae2d8ddc521b7894cc843efceff301856deaf55c81402b39"
    sha256 cellar: :any,                 arm64_ventura:  "aa1fdc2d1d997ff5e63da0625d7961cc7b7e7b75e6c4031ef42267d1ce277944"
    sha256 cellar: :any,                 arm64_monterey: "ba3030414b8fd5d2a556652a1bf5d7be188dddb8ad6e221e7d6662e295a00102"
    sha256 cellar: :any,                 arm64_big_sur:  "4e2b9c6ebec4fbbe3918044164a2ea7bfff0970e06e0c720bef8143d322ab3e2"
    sha256 cellar: :any,                 sonoma:         "8ed1d063b115127d0461606a589ddef863e39073dfbb9187a27470b7a7af8ac4"
    sha256 cellar: :any,                 ventura:        "029ae4c460d3454865fed73329f641b0788d9f4f7f2fc079b04954f0145e6e41"
    sha256 cellar: :any,                 monterey:       "b9308ddeb907678411916f047d9119350c5054afd5e995e113cf5ad287156e9c"
    sha256 cellar: :any,                 big_sur:        "f0e063340080998a098d428af420778bf27b0d5b772943b482152ad9e2793db2"
    sha256 cellar: :any,                 catalina:       "32a7e7e680f6e481353c0ab25fbfebb1f79f48bce4d2215d4765211e3494d450"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "93f9bdf4d9051c31897edf8d96ea5b78e55ec2d1b8abb4b5f05f06ada2d7256a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97750459321657901904cd492047c4d011d7e7b705d01ce37d82fe5622dec168"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    # Regenerate configure script for arm64/Apple Silicon support.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-libnet=#{HOMEBREW_PREFIX}", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      tcptraceroute requires root privileges so you will need to run
      `sudo tcptraceroute`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = shell_output("#{bin}/tcptraceroute --help 2>&1", 1)
    assert_match "Usage: tcptraceroute", output
  end
end
