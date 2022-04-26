class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.12.1.tar.gz"
  sha256 "4476bbafa4c387af82804ffc89564a214bf8a8ad8d9910235b2f4016130a7c07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2551da494976cfa38aec3dd920b280e08131cc3093a020af48c721c9977aaa89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e929d6b5ed32411eb591840ad96fda9bfeedc36c15d23ae6f29196ed7ce55ec8"
    sha256 cellar: :any_skip_relocation, monterey:       "032e98a2650c42eeaf6f73281eee5b84ca9159dc9868494618631bc06ea31ae7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9ecfc620285a94b2018c07883f1005c5ff35f4f4aed3a922c246b9cd7f84123"
    sha256 cellar: :any_skip_relocation, catalina:       "5b2189b2652ae0ab50457bfd20bbd9031992cd92fc9da92f03af038fbe49b30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08065ea0ee3bc325438157a6eab37e843629da7e9ef4e5724b4bde5b33eaf251"
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
