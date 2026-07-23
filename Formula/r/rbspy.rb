class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "56c574d1f3f1e57d961b6e2fd383497c68e7490c3968f6358e151645a3612eed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf0ac649b88792c7957890107b4e492fa558a190df861fc4e430651c7e33a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241fe2fee5f44f9fc80e872a80394816048c86c2476631b7f41feb68f0b8a5c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27950ddb3a5c6c72374edd036c613d63979520c790ab4c0b79fbb0f1380be971"
    sha256 cellar: :any_skip_relocation, sonoma:        "90323590ae132f4879603a264c37cb3335456ec13e9f9c9d04fa63bacec78076"
    sha256 cellar: :any,                 arm64_linux:   "fffca2ba973325b61a0c7e65e713c00521c36e5128f8082f8c1e5b6f51e33348"
    sha256 cellar: :any,                 x86_64_linux:  "4c15d92f5a198ed23f67c096062a1cc425571b0ca337bdd56a3fbfeac8046832"
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
