class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.2.3.tar.gz"
  sha256 "b0498467604c3f4eb7a1b3258ee9f37b709f7844d7edf338d40e85af40ede960"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b27802f53be5a3c30f4fdc5fd9a6f8c3855ecc40db3bdc2040b7be04fc896dbd"
    sha256 cellar: :any, arm64_tahoe:       "f294f2eac70d48a2bcc734d1bfddecf480e16a7be63dbd697c369bc682db51da"
    sha256 cellar: :any, arm64_sequoia:     "07565b20f02f9bf4ad0456d1b545d0613c522baf2d8b0d7d5f632216badb2ffa"
    sha256 cellar: :any, arm64_linux:       "7708758f152c9d20a4d637f1f292677024add1f64e25f9f909e9b4e10e249cf1"
    sha256 cellar: :any, x86_64_linux:      "d43bfdf4fdb8dfe72c475005a9486709d41a3bd031944e86bc57798c25c0b6a1"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system bin/"sslscan", "google.com"
  end
end
