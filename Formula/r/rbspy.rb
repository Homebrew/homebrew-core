class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "65c4a4f9e283b917ba2c84bd98a8ec14d3e67b7edf5fec2db9b047ecc4eecd80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80bb431179aa1c84905219c0fc519cc358751659f12d30c2a3707194a24783a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ac08e898b9bce4208c91ccaf89ce755d201c1e3649d96a33088c85234267027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2556b86d533c8487b9fe5a7c65cc59e9202ae9bfc2d21ccb713cb72c5146c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dae094a966a27c013efd459861a84837c1306645e364eb403c700509380b1c3"
    sha256 cellar: :any_skip_relocation, ventura:        "716d3b9070add4188821e3823ac7d878e461b4d0e70c6b36eda13e89d701264b"
    sha256 cellar: :any_skip_relocation, monterey:       "900d877bc2e5c7e327bf38aeb199ded881d58aa29d906155155a6d8e24357c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2171b2fa28b28ba6408d771de8ea2841a47f69ebc7b328a0cbadcbbe2071762b"
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
