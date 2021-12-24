class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.9.2.tar.gz"
  sha256 "987408cc4e2bbb62b8e30ab51de47116cb45a6ba3a52141c4502de4df61263fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe23c0c7e0fd0e3ae6511fde4e992b7b39ffbda8461c100176ea417505a80463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "837d377cff5fbf4c5376bc2f2b9d187393b871dcda1b3c8a6f33ee038338d4e0"
    sha256 cellar: :any_skip_relocation, monterey:       "04f27754ca33a07141ebea8a4d16acde9fa5958e15d40bdc229b0bcc22226a03"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebaead39ed198c48ab4d648a54bb97431f7d3a3624c9939e1d369042a6618c04"
    sha256 cellar: :any_skip_relocation, catalina:       "b1dbe6c7743c0f15844e39bff347df83d13cd4879b88ab6d0216519cbbdeb3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1046d93d7bddcedd5bea29794827abad05510c6eddbe6a769503fd4939d9bb3"
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
      100.00   100.00  sleep [c function] - (unknown)
        0.00   100.00  ccc - sample_program.rb
        0.00   100.00  bbb - sample_program.rb
        0.00   100.00  aaa - sample_program.rb
        0.00   100.00  <main> - sample_program.rb
    EOS
    assert_equal File.read("result"), expected_result
  end
end
