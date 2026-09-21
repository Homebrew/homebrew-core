class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9e1e18e32c761b97eb92d4c3680bcbe60dc2fae852c1dc339460ac50c51be444"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1badc963312bc7914fba98612947774cbdcaa3e74690d7c9c2db5c56cc09176"
    sha256 cellar: :any, arm64_tahoe:       "1c19b284bf057656fd5c6c6743493b1d06571ca5badcfb83229ca57de7d12324"
    sha256 cellar: :any, arm64_sequoia:     "1ab4364c0107dcc24d4dcbd0198b1c6da3a4e8acdadae31b829cf0660d1733d7"
    sha256 cellar: :any, arm64_sonoma:      "13547730d4662201ed4169a552f67f82587de2ce2a1ff5baf01f9afedca01bda"
    sha256 cellar: :any, arm64_linux:       "27ecf68b6805caf1b8630d77c60b8ef1715770cf391c70526cab364e616b5d63"
    sha256 cellar: :any, x86_64_linux:      "bfbe8efd92510eb7d3a57eb3a9e3ef55ffe3e14995537c7a1afe5c291fa074ce"
  end

  depends_on "openssl@4"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"

    assert_match version.to_s, shell_output("#{bin}/slowhttptest -h", 1)
  end
end
