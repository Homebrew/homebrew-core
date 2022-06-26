class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.36.tar.gz"
  sha256 "40f73bb3facc480effe0e771442a706ff0488edea7a5f2505d4ccb2aa8163108"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.tinc-vpn.org/download/"
    regex(/href=.*?tinc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3952cc168368b8c490fd9ee4886a14c9073736f498b52e37c98a2a5f25001f21"
    sha256 cellar: :any,                 arm64_big_sur:  "697c1a6266c837ae6f32ef0509b6d5770c7f723e5791b3263693fc8429baeb25"
    sha256 cellar: :any,                 monterey:       "f345428a6e452522d68cfde7b2d0f29a2a7e12c5880d3991ef7bd614b87f3b6a"
    sha256 cellar: :any,                 big_sur:        "5059a3bb30eaf4d339742ade7272a838008786010e709781bdf28856131229d5"
    sha256 cellar: :any,                 catalina:       "fcaaca6b5abf4f30a55149f41871a7c4ec99fe8a9dc87ddb68ea735c03569a66"
    sha256 cellar: :any,                 mojave:         "ba34dc41517f617c4d61d61e2f76cbafd9b75aa5edacc894e5b24e97cfb269f5"
    sha256 cellar: :any,                 high_sierra:    "a5ec2ae5f1e6252f80f33158bb0a1140e29764ed1f2e8754dcedf50e4fb49290"
    sha256 cellar: :any,                 sierra:         "923b15d1dcd7aafbb566f83edc9cced61b13379e857243bbe28b2755270b542d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda0235985da2297d12129c042544a72ba1e004cd82c996a2a5953b79f341782"
  end

  depends_on "lzo"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end
