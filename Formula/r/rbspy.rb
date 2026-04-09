class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "53106397e4d388c3ce9f6a86e11467a97859e63cd10a786279df3fc3c189875b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5695238b90b80ca3df2e946da4512a045180fe50556c120b39b0262e434db8de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b87291cf6cabb8b7abee64c7342e3fe335c988f2a33d8e80b6d4971950e458d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cb308e3e03109e2f373dafd4a3077500c2153725367ac94cc9e16145fa46872"
    sha256 cellar: :any_skip_relocation, sonoma:        "8045927134dd946ed914b89dec0abce34585a45c9851754c6747086f2557df8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb05398c614f98c9c5b8cff448c8eecba4628aa6cd5aec10095c39c8108369e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba11fcf2a4f65f23f6f557999040b0397e88937ebaa6e258f117017b2d99384"
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
