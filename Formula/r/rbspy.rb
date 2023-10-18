class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.17.1.tar.gz"
  sha256 "69c003ef9978b8727a1e25e9aac7337e2bd326a3783329031acc10186fb83472"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b54fca4f4dba7b7c14fb456c92691bba999902a15c173174fae50a3367377310"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb9f6fc7acc74e368b9ff4235f8e0a092b06c58df3d07ad0c29074777f88c55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f24a08d5cb41f0c48c9c7ce2cc872ac78cb4906405123efe9397546b8e547faf"
    sha256 cellar: :any_skip_relocation, sonoma:         "98fe6106eb8cc8f6573af08b7033863c5db3702500cb2e1e85f3b9c54fb511d6"
    sha256 cellar: :any_skip_relocation, ventura:        "a4961f7ede1b988bdc4fd8e999c54132974b27454386d1e1023d1eb466ec8c19"
    sha256 cellar: :any_skip_relocation, monterey:       "43c22a8b221f612cf307faf10febacb6649f1d466b2cf4f6993770126b20ceea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf5c3e4106bf47793b194b4792e29de1be0471dae600363f173e427c14b2eb2"
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
