class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/releases/download/v1.10.0/sngrep-1.10.0.tar.gz"
  sha256 "2a66d9b8b2a58f1a0486fe77760d23b30e3a98c7f2288a1fc8623826b6ebd5a2"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }

  bottle do
    manifest_sha256 "68b51c5f1a796fe824a74856a8f23f4648da899c485fee33884d675eff363ef7"
    sha256 cellar: :any, arm64_golden_gate: "aec20b8070889797d6f4f1052215988c376858f465091f36b85731138a2cf3a3"
    sha256 cellar: :any, arm64_tahoe:       "c1cd616349ad799c25356d4dd19f5df71a2824c2709f035c859041485d328b84"
    sha256 cellar: :any, arm64_sequoia:     "d297c7953ce9ad6b944dc6f3d214e972340adc45aaf48d66966b47d25b2adbce"
    sha256 cellar: :any, arm64_linux:       "a23977107cacf134b1725455e15d2e9c1bee30471110baaa455063d7b29cdddf"
    sha256 cellar: :any, x86_64_linux:      "e427575c8b5f3cee70e3e0d02bd960d398d10212b82fd637aab53724408cf90f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "ncurses"
  depends_on "openssl@4"

  uses_from_macos "libpcap"

  deny_network_access!

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("ncurses")}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-openssl",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
