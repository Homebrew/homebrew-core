class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "fd375237319b9b1cc906484e3cb63c00ecdbcf93f174f303785be39c81b2af00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de31b1d79134828fd02e3ef6e4f1efb1c9e1902a08dd12fb530aa8028e40d7b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d9bf4500a84c88741c584a12e2ab2d19bdedb18f4b03799f4d6ec432a7977de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e554cebf40bae44faaf922699a2b00ff1039431cf2fd1d394d709631ba3c1164"
    sha256 cellar: :any_skip_relocation, sonoma:        "857de6f08db69a579fc01986288eba3ce10b59804ccc7dac075233e6469bb039"
    sha256 cellar: :any_skip_relocation, ventura:       "255316abae5ec3b703e09389ab800eadb6822f6a8716530a4996807ae7e35812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f75ebc2b182def6438574645618a561fd8506bf9ed97a807f3db446534833e"
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
