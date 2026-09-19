class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "e5bd0126e6585d57fcb8deee7db3b04ffbdfad36074eb1b799b48791f6219449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80afc8b5e706c44c667038624399f95f3943c2486096f82c35662a19a12b7cc3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09cb739b765686db2135fb627551d8ea0ced506dfab21a789e980b8aa436d5b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f993a08f0d217d9346c9f5c046fb233853ee2c8b1852301ed5e1b299a46ad10d"
    sha256 cellar: :any,                 arm64_linux:       "ff440d14c7fe72133cd94a91779d6c78c9ec221644a78729a08d47babb2b1689"
    sha256 cellar: :any,                 x86_64_linux:      "19f773fce0990ed807d62f12e34a8f0f42f7b0d4b4ba9f9a7bfa263518745b09"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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

    (testpath/"recording.gz").write recording.delete("\n").unpack1("m")
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
