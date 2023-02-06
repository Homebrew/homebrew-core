class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.15.1.tar.gz"
  sha256 "0ef3fcae235bf26a2ef34a47ef15262811d161cba1b8241ebe32a8cf2bc8a425"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77b9cec9f2cd38bcb143b94f8a70b11fc97e74f55db479f00179387801ad0451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e90b858c87894eb23c6f21d3d8118697fc848ab5450b2a698db8600d6cfd87b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a687b436080b1b384daeb9207e5d5bc4336359e1d26462719b336a015532fa"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac8453fd9d74fd4db13ebc5714a8bfc10ee2344eab2c98f6feec20db2ea3b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "7be3df421d1a2e1947fc4c17964820afb1b79cebec8ee72f0792fe00d66fc61d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5205aa64706656c78c972ca6118b3d958ca4d962d2e559f5df56bfdcc1aabf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c1f5a563088dd0a5ed1a47ce41fe3930d4575ceef1594bbdf7f22ae06cdb8a"
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
