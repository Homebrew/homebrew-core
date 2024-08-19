class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "69f669d50645786ac7a3eab2fe82cf92680b0ee99458bc223c863c56c00d89b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7829cae7495221ec1ce4d3278f5d4bb0cc0021ed9157b1214abea34f899c9813"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e74376805012dd0b95377c3dd47fe43fa15f9ceea58579164fd1c731bbdccbc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e057c6417fadfdc05ba73ffcc84beeb960e857b4be38f212c2dd9e0f9ebc17"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c0eb34c5be75f08c06d8ece643ca7d57ec012d8c0dac8cf146e87d067b0eb12"
    sha256 cellar: :any_skip_relocation, ventura:        "ca9b774bd82cb3ea9fb577debbd4b97b8820d4c62c5458e3b46ed4e1239495c4"
    sha256 cellar: :any_skip_relocation, monterey:       "ba92dc7d143f7e784537dd0c81b8e93a998dc38f061466b81bf9835f9ea9f445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d1f4d12e15169abbb26410522d6f3b81955c14cf946e7755e2c7d3d0cb60676"
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
