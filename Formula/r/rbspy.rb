class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "bef36cf5ea8573f671e375ec0043db108012a16de5f68eddc9463a0058b0642b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09e476f1db7be2263e9b5608487870e74bd53167e1156e74ee9d12e20770eecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d078a3b6c06309d29372bd64cba7c79e6392e139c11db68da13548a2f0cd7c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbdfd15387f058f48b41bc0f8d1e0414edd706508a687f12ee1d214a81cd3eba"
    sha256 cellar: :any_skip_relocation, sonoma:        "108bf7afed52948a7ab822a1555bd2631a90d7f0d6f6921d56b18106b4d3dd9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f22435005956deb798920a7ad8ba169e86e3a9544c58fb0490c5679e17b7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9159f32ca8bffab4e40b45ee3abd2f7e82cf00b7a25fb37363f0a1a37b6b4b1"
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
