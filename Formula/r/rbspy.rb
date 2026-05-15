class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "15e91af20827074c15958c4aba9c9d88cafd3861031d41b6a6e7cba09a129d97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4badc12de841bfe15f4aaac964bfd590cc2f04c6825bc89af4e749a9999d554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79489467b909a9028763685993fa50adfb0e59c553110fe65d94c24160232f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f353868e6ff8d4c1dc8be451d6427a37b5860e59a0f6d53aa4518ecd27fb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b37ecb5799cc53bea176b65649af3118d6b99e7ddbf2eeed1a6058c34627c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17d2bf24c080dde2c0ce2963db33843eb16db4673f8dd13d7289c2e84f678e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6f8c04597fe7dc68015bae40e7590cff1399560f65d781aff11bdc4a034147"
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
