class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.15.0.tar.gz"
  sha256 "1319a5a3e0c9fbc361f4d7dd7dddc2dc14d21bf097c0bd0e153bf1e8768af6a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "595695652fa7ba79b0d830ccdfd632815f9bb3aa104fcc848e4046d8ba0d2ee7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df0160f83ed998fe7bae4036d17da8327b2622903e960762aa3ed387bc7d0838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06cd75965c2d6963757dc5d92c64d178db19543188166a8d779bab1e65bca752"
    sha256 cellar: :any_skip_relocation, ventura:        "79687861df2e7e647b547421d8d32d8170c044fde813f9452b69194ccb2635dd"
    sha256 cellar: :any_skip_relocation, monterey:       "5f3679dbd2d6fa30ab0939c2232687e3fa6f71907a7d5ae3c39b2a36685f184b"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ad4e52516d71728a69ebb513250994d48f7fed056d4d8627cebfeb5411d29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b87322c43131d8dfc9e012266a087b69770d689c1ed4500b083e516f1af1c45"
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
