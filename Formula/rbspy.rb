class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.11.1.tar.gz"
  sha256 "a69503e5385cb6a31a9db7bd2e2d1b93e4b53335062c4043e80ca9bfcf6d883d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29332686ffdebaeb7d5caff2874d6f1a7ce53b523410ec3da9c97d0ade5ff3d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed660d497a6538763ee89545b8bef061b0d8fd4dcfd8e8121b3769fc0f8d1b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "59dcdc99399e4196ec173d301948ab29ff2e4bb8559ed5029f4792685c094876"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1a8508394268e68b86e34debd642e5b800c1cca0028ccc3262ec2693869c5cd"
    sha256 cellar: :any_skip_relocation, catalina:       "7ec649b99bfae5d9453ea38e06e2e4dbf0052c36c0caa80d7e273a4b9f003c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8345874153371b79678f49f73fc97c2be535a63c2a676f057af302eb79fe274e"
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
