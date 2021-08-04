class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.8.1.tar.gz"
  sha256 "ddbec968d632dc9bac7b0b71cdcf8a7316d1ba7d081e3b981f48f6d740b80301"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9359d6249399792a0404993489dd8d182aeb8601f13f9a10a17751b742737d6c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7924e09701af1a52726b730b220cdf848a7d4b9819c64c537609f04bf5bc161e"
    sha256 cellar: :any_skip_relocation, catalina:      "cfb4270e47ab36bf526e030387df12348d7d56750bb9b3b32e82035e4ab7b5b7"
    sha256 cellar: :any_skip_relocation, mojave:        "5fb0af02ce2f18c6ba1ddb255355c2716c55dd1f41d5ed58deeae2e01ab87618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2d624641adc4cb2e60c967662de7f160cd2788cd6a36e3178d624b041cb713"
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
