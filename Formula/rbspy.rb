class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.13.1.tar.gz"
  sha256 "a1f1580f5f377a7d8beebfe592ceefcdb85caca87000f796901fa1e11fabb87d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2ac1f835a4b3df59765b8fc6f427305dfbec58ca05cd736effb9e0fffff8d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "677c64c90ecf5d74723e64211eb452970adc3af6e95959f6b29351d1005b5bfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89aeb2190cda7e9c747b23fdcd02ea616a3fe77634219e4bceca242e95d5ca9b"
    sha256 cellar: :any_skip_relocation, ventura:        "131daa48060afde502726eff20db4125345b9ea599f7f40120e21fcb4caad36a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a26825e1f5440237462b97803612f2a4f373ce183b748b4feb6f61434a61c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbbe19673d70d4009ca026c8c11c18e67e2d3ce1c841865dc53f8215b723e1bc"
    sha256 cellar: :any_skip_relocation, catalina:       "7ff2422b356d362fe9a84b080715db89d8777eae6eb973c5f2039097fb957824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34487adcb8e71b002e903ffcfaab797d66492b831876229fd83922a2759b9027"
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
