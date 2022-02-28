class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.11.1.tar.gz"
  sha256 "a69503e5385cb6a31a9db7bd2e2d1b93e4b53335062c4043e80ca9bfcf6d883d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2bdffc43edc682481587153c45d0a03771bb91f950f2b74e84abe740ef91e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75fad59fc8c25fd10fd51cae42f597d3b281448acaffc3e5e68508954f85d573"
    sha256 cellar: :any_skip_relocation, monterey:       "492c388d45010a2772d78ba087fd8ad788d7faba14ec761fe6ad912d2fcd1233"
    sha256 cellar: :any_skip_relocation, big_sur:        "610708a43c2c7e3d81fb55651322ca0d3fc88f41c19f1cf5844e082c912260e0"
    sha256 cellar: :any_skip_relocation, catalina:       "374a68dff5259b0676f24e2f37339886a5234bf33350149d7fd9b6394bc7286a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f20be28a1c59725de1417254c0ece2b9a026abbcaa989dedc13f74e31789b75"
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
