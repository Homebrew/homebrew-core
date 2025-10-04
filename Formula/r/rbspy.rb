class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "ca5146b36c74e9bb305e3cbf9e583c4b9cff0de5c8eec821d1ec5b52008e4202"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6888406b26dc431589a971935aa67b846f0f145cdf1e89d5972da4fa2859e7ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c1f25c42a528ff5665585ff51d5b2fa43b6b3387db825cc6d7f178628d1b71a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf7afe073b37f743fccc7030dbffe0c51e946943352e195d45074df48a03044d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e99eb5f15592aa5ca371870fbabacd750785ef9dce28555b3d3c8c1f80556c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2dcb94b7094c8c5e2030feae88642fb5edb7de593c4e8fac19b83b212d803c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "530976d65718ba60467824a509527618625e912ab7aa316e739c45e6c5a02ca0"
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
