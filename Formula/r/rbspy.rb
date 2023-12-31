class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "d8cc08107e47c8d9a025d8ff13cb0fec6b7d6eacbf3519b086b692a902a2e64a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e446a9e2034641db768d7847729e60302019bba6a9b03c7b9b5be19ac2862f70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2b3fa17b486e1ccc291f199e28f1eeb059438ffbb7f51c05416c6da4a9b34f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb2c564d6c00e06cc8a95bb682f323eee7a1be63a5bb695e26cad01dec688479"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bcd707380718ff9aa20812ac50cc67a40ca0852c95a57b9743e9c8d3dca14fc"
    sha256 cellar: :any_skip_relocation, ventura:        "d99065fc9ce6ce59290a3a2d13f5fe8c952777cdf8be6bcff3eafe82d12d0070"
    sha256 cellar: :any_skip_relocation, monterey:       "b9bc4e68f6b19948c4cd6e5ac38bc1450888331f983eedc008c539deb5a38835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "727def62eeb580c3ecd080678946ee83a7d4575746e86d1d469733d9141b2356"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    recording = <<~EOS
      H4sICDJNbmAAA3JlcG9ydAC9ks1OwzAQhO88RbUnkKzGqfPTRIi34FRV1to11MKxLdtphaq8O
      w5QVEEPnHrd2ZlPu5ogon+nq7sTRBy8UTxgUtCXlBIIs8YPKkTtLPRAl9WSAYGYMCSe9JAXs0
      /JyKO2UnHlndxnc1O2bcfWrCJg0bpfct2UrOsopdOUsSmgzDmbU16dAyEapfxiIxcvo5Upk7c
      ZGZTBpA+Ke0w5Au5H+2bd0T5kDUV0ZkxnzY7GEDDaKuugpxP5SUbEK1Hfd/vgXgMOyyD+RkLx
      HPMXChHUsfj8SnHNdWayC6YQ4ibM9oIppbwJsywvoI8Davt0Gy6btgS83uWzq1XTEkj7oHDH5
      0lVreuqrlmTC/yPitZXK1rSlrbNV0U/ACePNHUiAwAA
    EOS

    (testpath/"recording.gz").write Base64.decode64(recording.delete("\n"))
    system bin/"rbspy", "report", "-f", "summary", "-i", "recording.gz",
                        "-o", "result"

    expected_result = <<~EOS
      % self  % total  name
      100.00   100.00  sleep [c function] - (unknown):0
        0.00   100.00  ccc - sample_program.rb:11
        0.00   100.00  bbb - sample_program.rb:7
        0.00   100.00  aaa - sample_program.rb:3
        0.00   100.00  <main> - sample_program.rb:13
    EOS
    assert_equal File.read("result"), expected_result
  end
end
