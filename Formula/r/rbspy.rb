class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "e9ceff68994d5c264a40fc4a27e188f52190b2fd56c2d1513f7e82f092b9bf2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09fc9d527923a024f2d4c460c5908931ced3c18d707f39dc9e6e2ff405905233"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aa5867452209978ff4b8e50a3b6aeb4ae257be65f8531509961d3ca83385d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7975f9e94dd7747188bcfc8c3ab0a5613a750bea38198e4e3f143677424d856"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9ea3eeece4461ab6fc0aa949ae2514c174f88972c890d9bb258b923dac48bbf"
    sha256 cellar: :any_skip_relocation, ventura:        "9fba0c0702cc434ac4ebccb10fdad8c28d641ccc07c1c95a28fbfd6c654f4956"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ab195b159dada3aebd07a040ed041cffdb85a43c2075e48324b11ba2cda2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262115e658a7dd7d28c8d7c317c7344db0e9cb01c234d96fc28ef880d7550bb2"
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
