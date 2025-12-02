class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "772476d59f047287e20c2cc362937b518664621e100fa24430c3012a148088fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2f0b0b92679fdafa5a6e51ee24c215cd6924df304d4474874237a026f3a4bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f7dc7640bbcb16d1fe7759114cbf5523623edf992d38a8cf4d8d02ca299377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ee8d251c3dd4ac162a76c5f268de80c4a53e002d4997d40f23ce08e957d530"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a2d10f41e922088eb0acb2e54169b64e93ac796b835c168d24355ff571b629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6fcf3ee4878adba5757e51ec48fd2c50763777f0dfd6fa2789711c988cae41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146f90c744ddddf36132d9b0eaaa3bc66c7d3dfba083b3ca3d48c33cb67e949b"
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
