class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.12.1.tar.gz"
  sha256 "4476bbafa4c387af82804ffc89564a214bf8a8ad8d9910235b2f4016130a7c07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b76bd50a12b79904f336a0f9d8f7f08643a7c7ecaf28b1b6c85eb8a2398c216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d486ad7bca18e5550b2ea4093ca318d4f4e8f34283982fa0331af4de6759dce4"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd3b974af76123aee8bfb9304ca1eae2e772c4b2764f1625598f628f64307c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c6069474a8e1bf53db4699fafd1211f39c2a57b05962549c66244d2763e7b68"
    sha256 cellar: :any_skip_relocation, catalina:       "71103d9304aa859ab1b46c26b971c196432ba38fe4e28437a657cdefab37ef6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338ab57c0ae1b9d37fd2cbd27ca9208e57af60a9ed918170a50330fe7a3d6f86"
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
