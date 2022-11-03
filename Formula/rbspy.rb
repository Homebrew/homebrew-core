class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.13.0.tar.gz"
  sha256 "31ac92a5c054588f77911c33a3575b697b18f0aaa307fd2409a25788de212eda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cc66d43f7ae6a6adbd2ba20fb0e309ef75a222dcfcd0d9198e2657239f28767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7586dcd1c4d87ff6fe0ca679f7c137ecd8fc7325c45217f56149653b25c5e7c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32781dcdf83e39121c80d25df7b32ecd44458a65a850120b89f2fd7df3e1e55d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2dbb3936a7c173779cc9988418be2391f46d24d9efffb9779fbec24cf10bb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd3f8ef2fce2a263b83da05a1ee8691699b20916dc7e719593f49f9ea485a60"
    sha256 cellar: :any_skip_relocation, catalina:       "f021109ac5a6b269621d7ad5b771eab0aa8f74899b283c02efd1c74d5ac6a464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee828b31d74158dcff96062093f490145b3d18700d42b5124624fd7a02cd2b7e"
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
