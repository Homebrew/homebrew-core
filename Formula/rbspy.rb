class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.10.0.tar.gz"
  sha256 "f141e907d690e9cec4a93b9e0c2cbf2047d411a576c71ddc8eedab2968252ed9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6006c6eacebd19cae7ce241a953b5bbb92f1181ef3943501d6d573776f1d9b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb498db341f883f35bd9ea7628161d3747111d6e878eb76aa16210e0867eeb3a"
    sha256 cellar: :any_skip_relocation, monterey:       "f68de87804d10d0f1bd5180958a1bf83b25e6fe7fcf9869871ae20419ae23ae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "301e23492d6cedcf8b5e0467275cd7d2045d28ed2c0496ea1ee4302380624f25"
    sha256 cellar: :any_skip_relocation, catalina:       "6dfa289c70eae7356227754cb7adbe15fdca974b9c7a970f512fbe3941c72a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d77928489bc84455032b5f6ac5aa8a391fde00a3bf593e4e5a70d3107c76939"
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
