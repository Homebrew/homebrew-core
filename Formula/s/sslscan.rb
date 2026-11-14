class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.2.4.tar.gz"
  sha256 "93674469cfbfea7326e5236165b1824df5fbab32a9e0499f03edc10b36befff2"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5affa86ca299cf3baf966cd8db948146ab031aedec56d6602682be0714c8f862"
    sha256 cellar: :any, arm64_tahoe:       "1876b6c059d4dbb162e7461215aaf849b1e9cd85d0fb27ddda329b5b1f345cf8"
    sha256 cellar: :any, arm64_sequoia:     "96ed176e6d46c69085bb57badaf1eebb1cc19a4b4b60630e3965a2f8e578a2da"
    sha256 cellar: :any, arm64_linux:       "c854adf8b2d6d4e822f5555bcc8aedf964d63c499b589ca722e17f2cb5db8dfd"
    sha256 cellar: :any, x86_64_linux:      "1afed49f567a604c638cff4b9828570add06febe8305a924aa7e374ab00c9b00"
  end

  depends_on "openssl@3" # TODO: OpenSSL 4 issue - https://github.com/rbsec/sslscan/issues/361

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system bin/"sslscan", "google.com"
  end
end
