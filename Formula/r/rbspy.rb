class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "b63aa137c8ce4124fff080d4f42a05d61601e207147f9db9ef66519ff2081b8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ec833dc4a85a1955c6cf05c29d082d7649cba8ed17ad256709c8c95248d2247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016e3356e838454c0890603e545984565528f56bfdc22b1d54c221baedbf3ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "475ff1e6ae0197cfddfb684bb0ee157bca9e6f5fffbac8716196daf0a557571d"
    sha256 cellar: :any_skip_relocation, sonoma:        "492db13127b0c41dc8b9102c0af4289f17c13db45a6eb53482627193caa97f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc71c683d32ad051e4a2e935065a5f047aa83245f07d18381408cd877d6dcd3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8058c2282cd6813e7fbc66e2b61e1feedc0d8ff52ba991bb086ac9c70d3aac42"
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
