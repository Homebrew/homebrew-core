class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "dfc75d5a28364903afb8c19d47491a4e09d3dc3c5eb3129b132a54f233fb719d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d9acf098a9cc08bca0f060c9e601991c173d2c88b0fcd97235db38507985f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c1f14aaff920da812d5b11a666eef97bfad17a2967f3100f54bc2b213fecc05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dd63419604e367fe3dd7dd1ffb8554403b8bf64faa71282f23ef15273b29cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b23018e1ef457057335bcfbaf7d2f4d112035af4e6a09fd9a424def7954ba6"
    sha256 cellar: :any_skip_relocation, ventura:       "3a4d1e24c895bd60967b06503577e20381d58664aa24c6698efcb54f74558244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff9ad252586e4e39b610deec8295bc70e0353b2d2b9f0c3402854389f6888b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc3831ba4a1ad6e20fe77662aea1d66ecb71082ccd8836cdb5aaed7b93bc752"
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
