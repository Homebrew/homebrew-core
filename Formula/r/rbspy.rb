class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "78ce4c109b077446eabe826b8901e0a5e683cccf6108bc2fa2ae2759674cd49b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a339007065d5ed1cee194b84b121ce00d54112f57de03062a276cad320d6218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef739d25b345ab509789914d3f5fcedb29a3a224bf0ee93793db5ab2f030a238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d025c2c5b65148b34b8ec4c0adacf707eb85c0d03491b87e6f8908eb0f9007ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "337ce7188e78a9f5348fd4fc7105ba65067a9b7739a529acbda117701102c48f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eb7a3200248f840f7ac72d47f8ffe04ae7df41780ebf9c550c9e2101a08b40d"
    sha256 cellar: :any_skip_relocation, ventura:       "6a99a79293fe4b743f63d6e331d6bf199c4dcc12afd856d6dc4e4ef1dfa8c62d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3875b03d465cbf21842a9895606c5c6e79d66e690ed77d5c808bdb2a23f5e2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289d3b1f6c624236fb9a3d07e6a49e556d94ab503a729837b1c19861529e2a7b"
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
