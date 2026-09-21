class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "e5bd0126e6585d57fcb8deee7db3b04ffbdfad36074eb1b799b48791f6219449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc580b05f7536de13ba5e5ee6d791b00689fdb87e34802952c72877543a1f517"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "798e98ab633c0acd1a6f53b1ff2e8a34e932094dec66a040cb2ca9e3858c2f39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b19b832a99813c9395c00bb0283d792110c9e4796fae7e48b62092ca8ac51137"
    sha256 cellar: :any,                 arm64_linux:       "008b1f7ae5d5d9139d4099526a03f1b4d8828fa144f3b1c5e7539c2ff1d67436"
    sha256 cellar: :any,                 x86_64_linux:      "dd44eb13bb227e30188dc7322ee7e12101b2082fef38c8e2f6c4288f96731461"
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
