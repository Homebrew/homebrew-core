class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.17.0.tar.gz"
  sha256 "4b5b64a42c1a307c06886b2686d9496e0df205fe5e1e98ef9e3ca6ed226753c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dc126b0a49def8e3a49793fdc1edd73a068fcd2a34b99517e6194b51a632b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12ec10ea1407788ed3576df1be9e47db6a427a68eb2203370f4795c832729be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb7dec819b4fe0828210578fd1ce8808a58c30ef4e294ab2b036e9cf022a355"
    sha256 cellar: :any_skip_relocation, ventura:        "23f32126302b871f2f54648e4d72059993523c677ca466872dc3b52db0883297"
    sha256 cellar: :any_skip_relocation, monterey:       "f66fdde73c377432fc2f257850d59dd6bac2b88ec9b1aecf12673797e9270c4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f730f2de73fa864b289fbab760d48cfb19cc3603d65fd33c24e6c51ff8051983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f86521dc6824d941786e647317193466b849c761f2481bbfcb2c02b95633952"
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
