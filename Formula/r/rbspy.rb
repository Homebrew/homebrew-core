class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "2be0156079e976f7a3e846edaa12556296973fac2d7a5ad5d4115fc3a4b08c8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b510c90ec17ef141b2c21c7c8a39b2ef95434f22ba964a3d183a22c0acdac527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec18559cf15cb99611205b790e1d947e95cee7ffc4b16783421c1ded48710cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b851a169a9e8988f1978f220081f34beb1098d23c68c29e2aa092968514b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3206b627cfdb6d7c042d9a59f5a626aad91674c50f921af69bd67b01eec780f1"
    sha256 cellar: :any,                 arm64_linux:   "0b3613d9405c91f6c6b76abc8f3e2471b45d5b6bf44c06514e0e0a52c59f9fac"
    sha256 cellar: :any,                 x86_64_linux:  "29841abe96bdea0edecdcef22d90a7d183591bc27da1d3fbcc5f06c1a140b123"
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
