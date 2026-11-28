class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "0108a8539103fe9ba86bb4500a7ec6d67770681eb02a1c84196e4fa7664a5ae4"
  license "MIT"

  bottle do
    manifest_sha256 "2d7d8a11a5cd8554ed78586d42febb36c1dea85ed0ea4246834456da9e5ff93d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8110804d5150b2e7ec98213d50f86f100f9dc36c815798b9ca2cc715244331a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb0b474f4f1096c43bc3bad1a69a54eb171205565b7a0eac53bc31bffd9aaa1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d73099add17f5f11f9813e1e6b452474a5d17ccb8fce020409035f576758b2ae"
    sha256 cellar: :any,                 arm64_linux:       "78bb4516d0e2649878a209288cecd80252a40b655252637982ad331d87df1ad7"
    sha256 cellar: :any,                 x86_64_linux:      "c6cb5c646d6e62ce9d943969fa0d2da827a14358ca7b6fb392919c99290c0eeb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

    (testpath/"recording.gz").write recording.delete("\n").unpack1("m")
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
