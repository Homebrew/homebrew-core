class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  license "GPL-2.0"
  revision 2
  head "https://github.com/mct/tcptraceroute.git", branch: "master"

  stable do
    url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ba3030414b8fd5d2a556652a1bf5d7be188dddb8ad6e221e7d6662e295a00102"
    sha256 cellar: :any,                 arm64_big_sur:  "4e2b9c6ebec4fbbe3918044164a2ea7bfff0970e06e0c720bef8143d322ab3e2"
    sha256 cellar: :any,                 monterey:       "b9308ddeb907678411916f047d9119350c5054afd5e995e113cf5ad287156e9c"
    sha256 cellar: :any,                 big_sur:        "f0e063340080998a098d428af420778bf27b0d5b772943b482152ad9e2793db2"
    sha256 cellar: :any,                 catalina:       "32a7e7e680f6e481353c0ab25fbfebb1f79f48bce4d2215d4765211e3494d450"
    sha256 cellar: :any,                 mojave:         "99c51ddf23c5a4c9ac6d853c39a03513b340e60aa2d57211a46ea58bbad7290d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97750459321657901904cd492047c4d011d7e7b705d01ce37d82fe5622dec168"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    # Regenerate configure script for arm64/Apple Silicon support.
    system "autoreconf", "--verbose", "--install", "--force"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
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
