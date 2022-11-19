class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.15.tar.gz"
  sha256 "0986ac647098b877f24c863c261bfb7cf545a41fd1120047337dfc44812c69a0"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "6ab6c4305844904c0b9dfc7d2ba86a48bafe2e64c6a548718e2e5cb0645d2ca5"
    sha256 cellar: :any,                 arm64_monterey: "564ea98dcc718997ff93e4ec265795a0ecc4cd233b4084c3941311cf4ed05345"
    sha256 cellar: :any,                 arm64_big_sur:  "34d194e70c43c06937e78d21468d881950b5a197fcf719278340a190a2b71df2"
    sha256 cellar: :any,                 ventura:        "491bca8ed92a8910645ddd059febe8b1eceaf1c0ac9a58499395da2f314699a7"
    sha256 cellar: :any,                 monterey:       "93da99b49f6dd190ec22338e4926b905f077695b3dbaf2e50b36a70ab1641e04"
    sha256 cellar: :any,                 big_sur:        "693cb3fda53855f2d38e50a0c7ac1d0979f27d8ab08d93780d7cf454e954ebf6"
    sha256 cellar: :any,                 catalina:       "07f57f95634191f1a8ab4b1e849bee389d4d3b01c824f643d507d28252b18bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f8070195f33e7ec00b90991ec618ee1be4fbc9c1340cb00cb6ade5a8cde929"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
