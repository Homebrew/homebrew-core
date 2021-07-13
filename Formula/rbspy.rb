class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.8.0.tar.gz"
  sha256 "9c838b975f7d150bcd4b491a09b62e489647968b6260a35bb77797470a96392e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f17e713f64d3aeb6000e6e1ed32510802f72f7b34fd1f6894c5935b338ae158"
    sha256 cellar: :any_skip_relocation, big_sur:       "77d8dc599309ef48e956a4ca4d94170eb29589265a1ee23bbc82e7120565c740"
    sha256 cellar: :any_skip_relocation, catalina:      "0ff9f05b00e53cd8b6c43b961fb6de6c82b6f8438d7386bd9c2265e0072ae427"
    sha256 cellar: :any_skip_relocation, mojave:        "892c3411831ea4db2d9ff1bfa6e9af44fdca29c9596569c0641f7a1043659a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcda930c74b472b77be361c1f0b0809d7e2696a2a242f3424ceb4a4e5cbe6c6a"
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
