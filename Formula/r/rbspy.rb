class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "2daf337be9db6d3ba17c0a6a7339c2bbd4424ac68c98739bd01c3b4e45a4d947"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09c91a5094684c1fd2d272ee40055441e581228b4e97a3032ea9ce99fc32045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a654a29a33d667819377fbd58cccf47c51caaac20ac319da7dad23d5b334c913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74962c5586668bd9bbda22c6b1ad6c26b29fbb8ed401ab7e0020c3e794ca46d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f380435e140040391caf298c7c9abe6a765e0169d8387125709ebd3f32795be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea9063a2b252b30d08b4a81e1c3a18d8dda2b37d68a66b5e8ec463188186fce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f046394a7b654091559b3b54d09379ebfe01f611576aa8e1f26180c03408abe9"
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
