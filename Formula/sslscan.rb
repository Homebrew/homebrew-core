class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.11.tar.gz"
  sha256 "74bdf97c834b961afb342cae1ea32067af0e05f58239979d0f2d3fab82acae1c"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37745e63d793135ca96ffe7d28637c16a63c1b4d1f6e899b98a2af102159d67b"
    sha256 cellar: :any,                 arm64_big_sur:  "f5b4783554adaf8668bd962997f47b666acc0e5b83c5dcf32744371e0a19e5fd"
    sha256 cellar: :any,                 monterey:       "b57bc665595104ecd708246b49d7184f70e557e35b6066680752cff811d45ed0"
    sha256 cellar: :any,                 big_sur:        "dd0b57a82a99814e2e21c8d8b076207b7cc1824ce4f2ae6e10ad57eb318c3f89"
    sha256 cellar: :any,                 catalina:       "e13086894f20487eee91a42160b7b4d891851e26a23184be8139bca2f0392022"
    sha256 cellar: :any,                 mojave:         "30d8baa596df4a6ccade6d02bb77f73747d0c5dae2518bf0082f9aaf2fd8351b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4922f8701dfe20d818eee4fcf6ba010b7da4c927ad0389e00181eb993a4d0d71"
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

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
