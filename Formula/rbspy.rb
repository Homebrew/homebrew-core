class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.16.0.tar.gz"
  sha256 "fdb667d542431225cc30b19fdae7a2950b9c15731a3559ee54dfadd2bb2b6790"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec14d99fdfbc6849c091791a1b88ee59c2110fd81d1deb91d60aac36563696b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99959d07c5bcf2929aa28675073945548c34ea4e4d8aefaa3ef27691d30c31b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b376c2f585f1daee433b1a812036a85fc84ee3f0d4a5b584647cdf7f833ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "4d71a4b27aad9cf24209840f049c87174902bc31f3c44cfe34751b0d91b37da0"
    sha256 cellar: :any_skip_relocation, monterey:       "120012b69574ce0eb4e4fa3efda9596959a0e558d6c9741ef8836cfaee931412"
    sha256 cellar: :any_skip_relocation, big_sur:        "75e802671b8ae5d6b1ca6e4992e3cad080cd2ffd2c0df63b28d42047afb5cfa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20fbd09c66776715a366f89be3ed40498e8cd8fca77d20e9fc6f81968ffea561"
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
