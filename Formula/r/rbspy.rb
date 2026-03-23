class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "1208f2ca34f6f1eeaa31d0f433083535973a1bc6551e604eb9f217b2abb63047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5f54091e788628c942f09fd0abc2fddd85b177273b14a398edc801c80217521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68b1630eed7f00018fa4a154bfcc01750be232cafcc13a5ed754ef0a90b79ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de7f054be0c2290a36c0f4fa2e2a53f7fb60e90390aa8a1dfe812b697a6208c"
    sha256 cellar: :any_skip_relocation, sonoma:        "992f800306380ba140cafb6f08d9fbc7c1eba23b2af67ebf10325045191c552c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bce5827b6c46350616e49a9d229d3e398f1275fc51dcf7cc5e25ebc43b2dbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda770b1f44ac06629d90a1162ddaab497210dc78af519f993017f7e46d4f3ca"
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
