class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "438fd9752531cc9404b6329c106627e937a8d67eec156d1f3b25fa5e30d727f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaeb2d0446dd8a64d5bc1e41a2a9f1386473c41658e576f3b4dfbbe1e5dbe0e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d74091f970755e304be6c97823ce647238b23c8f1ba20f9198d074a57b10f76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51c5f8a7228cf08f15eb111e344f7ecd803ee1952c6229783c0523b36b9a3d50"
    sha256 cellar: :any,                 arm64_linux:       "591573d2dc578583d9bd389a2cd02046760721ddb4b025da4c1fc448e609b883"
    sha256 cellar: :any,                 x86_64_linux:      "524163323c9e0c771410c681c7587d651e03dcc47f73e940c7a62474dbe1ef23"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
