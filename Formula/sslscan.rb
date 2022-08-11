class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.15.tar.gz"
  sha256 "0986ac647098b877f24c863c261bfb7cf545a41fd1120047337dfc44812c69a0"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6c11ea960d56ce6637daf7c5bda05e6d6bbf6dd04b6bf4171b60f7d63fae499"
    sha256 cellar: :any,                 arm64_big_sur:  "bbef0feb49d55b17a6dc1be5d7544b7afea935cb8486a06ce1a000397082ea3f"
    sha256 cellar: :any,                 monterey:       "c6db8bd7356bc42a6762ffc3bb46f52d13c0cdc6b9873e3977b314b51cda56ca"
    sha256 cellar: :any,                 big_sur:        "a730c123c4487fe5b8d3a7a3da7fa6d3709b618f8b8269cf457d5e56c234ec01"
    sha256 cellar: :any,                 catalina:       "0c419d351ba903c3a1730e344a1d3e5b954b11fd68f339bc94fffc00c1967432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f447f3e86abae4d2416993b72e4a32068478203e4a2fbdb10c3de410f0dc90a4"
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib|so` built from `openssl@1.1`
    inreplace "Makefile", "./openssl/libssl.a",
                          "#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libssl")}"
    inreplace "Makefile", "./openssl/libcrypto.a",
                          "#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
