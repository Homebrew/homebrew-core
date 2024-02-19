class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "b037dc864e9f590ef947a0da444cf3eb15c7ab00ea0a037ade24fa0a33a62a06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597c832bb9b11a12b8ffda9e19140566318e0ed986c1207944a484eada6de18f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e85cbedfb30f2b0d7e08bc49a5d700f6a3f398f058a482a2f9482d8baa7ca2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3c43b98d07d66d3ffdaa18d5ce9972d8c6a5b2f3e7af217fa3039a0e18e52c"
    sha256 cellar: :any_skip_relocation, sonoma:         "18be3c77d1fe3ba810ff40c6afd2ef68846190e52ab204c40fd5e3a43043f3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf2e73b28e2d7bf05ec90d1a447eabc3ddd160b5267b06935ae4f1c6c2cab07"
    sha256 cellar: :any_skip_relocation, monterey:       "9b962e26157404429412dbd656a07a242ca0361cac5d7beacd52056d85bcf89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c4d4cbe4dfacec8208087f62d738e5b81de4aaf9e88e82212db1cd7f6c143b"
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
