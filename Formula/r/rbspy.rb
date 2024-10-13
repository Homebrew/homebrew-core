class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "7d1541ae9ce3ed9085ca4c0e4e77ef68528b9ad60b9a3ae5b98f1fd6834546d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2b62924954465debbbb355392b8f564013cf505d38be3d76205c07c201d05311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a98ae1c1d6b63f379857304ac41ba61d9fec89804bad7bfc2f954335ad65549d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53a814cddd440cfe1de835214a19bc5064784cff87096636cc29aa2ac52ff83c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c9896a06aa319d680b7bf0f4a96be4ff864d06dc4af27bce32ae2516ff0c80b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3f18bd4dcc0948418e8d61427dcdcb5aea2cc7daeaebd240b2d06fe0d565f16"
    sha256 cellar: :any_skip_relocation, ventura:        "e643b622a5e3b9efc19ffb6ce770809053831b69584bf0a10bb1e9934ee5d117"
    sha256 cellar: :any_skip_relocation, monterey:       "dc01645fd24c3f34ee800e84cbf9726790fb680d8a928077891ab80ced4a0a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0651d9d7dfdac1e06bab25f75b54ceacb58259975752a87854ab3812b1105a"
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
