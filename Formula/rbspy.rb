class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.9.0.tar.gz"
  sha256 "686f42289bd5ca8818dd87353fb22945cf4f78ee2714d8dd47f691b56852e43c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31fbddfcad0433c78ee28c334e4f5248cd3b63c499723882290063fc3fa37d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a86a5b1fa285ed25ea69eafbbbd60b0e694fa10b1552c5de003204088dff54a9"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d86634959eacf1cf3d7b7f912bb875b8ccfbed3f0f1e7a2d9f70ef1457a003"
    sha256 cellar: :any_skip_relocation, big_sur:        "d028c26a29600b213e934823f3f14367ed36edd9e34a0b7865eb0ab6e8234da0"
    sha256 cellar: :any_skip_relocation, catalina:       "94e6dc8400a2b6c2d5bd62531bb5907c973503d46a5bfa36f9d9dfe33b0e3948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d35f50c23ae35212a577ef0cd9488e26014dc37930280a93ffe36bbb215336"
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
