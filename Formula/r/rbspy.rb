class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b266cbc18546727c2765a5cd0b77dc0e852c824d3d5921ec2b6ad223e969d120"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7609c95dd717442aee3c4097235ff6e9450dbdfb1f7c3d3f99b50e8f552951b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0701aed281c6f7fbfc77a87f98eeeb148d8f2a4a6dee78a5917a2d7042d76628"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e50c9cc0421c9105d3ffe681839029f8bc2d451d5292c4907b2543e3bac1b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9ecc3ae0d08a27fe4e27e222aedbaf8ef4ddf5efd13ff8a31e9b2e9233bab4a"
    sha256 cellar: :any_skip_relocation, ventura:        "38eb3cd0f063be760c00a4799b7871cbe5c20038c9d46eb6a2ea459564969762"
    sha256 cellar: :any_skip_relocation, monterey:       "71efb75ce2b382966fe3d49edc982db6ef5a9896e01abbab0702b6a7412294a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d93d062f2a282c0e57703d92337fc055400f0d0f4a90a46b982ab5e8f26c226"
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
