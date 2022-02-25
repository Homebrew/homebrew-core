class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.11.0.tar.gz"
  sha256 "6c482ad40ff0c882c3b056ae6654a50c92cd110cb8bab1d313a473d64a479dd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e6ab3dc0203e3de1d68378b2133e51b166620543415a1afe2972f3630ddd66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f4bd06a87529ca006f27b8f1b3d9f4e7cc9a5340e209a6b5384be734cf7df5d"
    sha256 cellar: :any_skip_relocation, monterey:       "365667894b7c3712eb2a685037aedfd047bdc209a00f57f4941f55618c01bd1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd76b94d64e21d649529bbd389e4b84258811e6cffbec67ac6e7941adc6f4c3"
    sha256 cellar: :any_skip_relocation, catalina:       "0ed9364440583663a8c51b6c50e7468dd463fc992a88fb6d129e5797f4a7ed10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad4964a3a75451ca400e019bbd3f3374656943198bb857e31161e3c6fdc62ad"
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
