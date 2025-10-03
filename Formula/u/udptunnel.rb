class Udptunnel < Formula
  desc "Tunnel UDP packets over a TCP connection"
  # The original webpage (and download) is still available at the original
  # site, but currently www.cs.columbia.edu returns a 404 error if you
  # try to fetch them over https instead of http
  homepage "http://www1.cs.columbia.edu/~lennox/udptunnel/"
  url "https://pkg.freebsd.org/ports-distfiles/udptunnel-1.1.tar.gz"
  mirror "https://sources.voidlinux.org/udptunnel-1.1/udptunnel-1.1.tar.gz"
  sha256 "45c0e12045735bc55734076ebbdc7622c746d1fe4e6f7267fa122e2421754670"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?udptunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "955432103c2a78902e1560848604ef6aff9513feef9603f1f6ff10235136e8a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be4c5ad4d4094dd6afe8d22aa7ab5fad4a53ca8605a4d9c8b379f209076fe48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68d39772c6215367e95610b65557e2055741cc6f1647f0c203ecb1e2bef0a617"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41ccbefe035c6cb8d7cb3a1aaec9421819c18d02f909b296c8751ee541aa585d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb91d06c314bf6dea17191505ba382300f7a5b8551c973d79f516ba769153a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6d79761a7e95026828863a9ac3b4446603008c36610b651d2ad2b2a73e3110b"
    sha256 cellar: :any_skip_relocation, ventura:        "8f92018d640442578d0d26e06ea3893666da7847cb88acf76ef3dd6530f55397"
    sha256 cellar: :any_skip_relocation, monterey:       "b81e584e4ed1d6e579829e55488fe8ff398862d36f0619867b94ec4fbf6d1f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eb84b77db4dc77640e9ed18c024af27dd1557dc6f4ec00acd374791a2f461664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af4f9f7bf957a343e94d7dfeb746dd2a6bcf80e9f6689fcb083d281494f75ac7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "libnsl"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    ENV["LIBS"] = "-L#{Formula["libnsl"].opt_lib}" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    doc.install "udptunnel.html"
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/udptunnel -h 2>&1", 2)
      Usage: #{bin}/udptunnel -s TCP-port [-r] [-v] UDP-addr/UDP-port[/ttl]
          or #{bin}/udptunnel -c TCP-addr[/TCP-port] [-r] [-v] UDP-addr/UDP-port[/ttl]
           -s: Server mode.  Wait for TCP connections on the port.
           -c: Client mode.  Connect to the given address.
           -r: RTP mode.  Connect/listen on ports N and N+1 for both UDP and TCP.
               Port numbers must be even.
           -v: Verbose mode.  Specify -v multiple times for increased verbosity.
    EOS
  end
end
