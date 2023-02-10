class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.16.0.tar.gz"
  sha256 "fdb667d542431225cc30b19fdae7a2950b9c15731a3559ee54dfadd2bb2b6790"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea47286f852e9c5e37ade1ae26c8d0ea9c67e829c0f807b0e75c415f2728c625"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91b13138bb609cedd332ced8802dd87c30c389875d70047423c0964a39bd89a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fecc989498398c134e69df256ee3ef1a12527139a8a7cb0d68491acb714a8019"
    sha256 cellar: :any_skip_relocation, ventura:        "41d89a65e565a89f94efa74c346f7f69f61ef05bc444adeca5ed22eef262bba6"
    sha256 cellar: :any_skip_relocation, monterey:       "76237c314a1839179a30e68957ac43db26bf42f970248866b0185852c3f33963"
    sha256 cellar: :any_skip_relocation, big_sur:        "445e02d3da241a210d25308a29c3266b92439766aa6c05e84dcc286df890e8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83dc04e64802327f293fb17d48cba8488c078364bad14c03e478c0990c63004c"
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
