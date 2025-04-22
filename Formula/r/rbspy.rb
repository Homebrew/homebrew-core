class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "3b69a08d54a1ca9e36173f0f95cdb1a6acf479a29010d40351187813082e6b9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8c553b25959cba39500a65e4076c1812995d438176d0ff9207c4fa0aca9c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0e5fa8372d8729d274445c70b378861a798441e660e5aa84bc06494da0b20de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61636d45614813617bc84fc1ff8a8b423bb7ae2fa53ea4e8e46057cdcd567022"
    sha256 cellar: :any_skip_relocation, sonoma:        "acd986789548441e5442c10aa0a93b2a99c5279d7d20bb852037b8fcf4f7a290"
    sha256 cellar: :any_skip_relocation, ventura:       "8ce3db2f9e2eac9d9cdb9b2816fa18cd3f27182c03115f365007974f0618a436"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e834d25fbb7c2490575db059e809e0097df2708b3d784db1f04cb678d14045a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d82d9e289db4d175b4ed6f95f8aadcb849377386f67d6277946f83da3e8ff87"
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
