class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "4a212248e7f9d29ab374f0bc625ea9e791d0eca5c4e40e95f6e20527a5a01eaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc0ee354c2705e192e8fcc7144608aaaa7f7bce089ce6817ac90ec25ff6379b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe3c57eb8278149a9baf8b6e087f8f0ccae3a27135d7d535fca9ad40af92a62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b217cd465ecb9ccbcc3d77a5bf0cb353e94c77ef87e041044ca647292e6c1e79"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0866a735eff8787f1800ab4aae2ab7c26d20df521a5eae191a32da1565ec47c"
    sha256 cellar: :any_skip_relocation, ventura:       "a495543c22dfdf3576a09ccdba31fd2c19afaa43750fb46f7fe2a01ccf7ed524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1672baf62aef6453c997b3394e377af37ec6dccf3f57d033e3547c7c6e7e65e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccff00ba9906ff5c7a2e7f965546fa81b4f4975018ccfd7bdae312086d7df5ea"
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
