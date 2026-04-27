class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "055c59b2180e7a1d192d479b9e559312fcc8100d330c9851a0b632c1f793fb4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71cb827a7a8d326825d475431585af6508a85be05bd0f5ef8b1f3552a7bd5577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf95e99d99e880a7671037c9231ead8d65b09a3ea6911ea0a6fec4234c1a51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b9406492addaa36cbdebb870da6855d1aa4b12a50ba37c9d010de3de2271384"
    sha256 cellar: :any_skip_relocation, sonoma:        "370478afd1ad5f6cef5e7e8d16d88bfdb4ed5e53c6e37acbf8c0d161614ccafb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f191022eb17ba1d3ee112da8c3337f989973e4d3b704d158cd0bd2d4055d45d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a34a96471983e8f5a47e731cfe87f73e082c41a99c03d9d1f3f9bc1e491288f"
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
