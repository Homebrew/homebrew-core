class Sub2srt < Formula
  desc "Convert subtitles from .sub to subviewer .srt format"
  homepage "https://github.com/robelix/sub2srt"
  url "https://github.com/robelix/sub2srt/archive/0.5.5.tar.gz"
  sha256 "169d94d1d0e946a5d57573b7b7b5883875996f802362341fe1a1a0220229b905"
  license "GPL-2.0"
  head "https://github.com/robelix/sub2srt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a07867d66f820fdf3f3f7318364bd008a6c20ea42cde7c13c299d8f555a6453a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f16a9340a7b75f7b52857699fc0345b22a2e6c1f01f5eacdef6920cd7146505"
    sha256 cellar: :any_skip_relocation, catalina:      "8f16a9340a7b75f7b52857699fc0345b22a2e6c1f01f5eacdef6920cd7146505"
    sha256 cellar: :any_skip_relocation, mojave:        "8f16a9340a7b75f7b52857699fc0345b22a2e6c1f01f5eacdef6920cd7146505"
  end

  def install
    bin.install "sub2srt"
  end

  test do
    (testpath/"test.sub").write <<~EOS
      {1100}{1300}time to...|one
      {1350}{1400}homebrew|two
    EOS
    expected = <<~EOS
      1
      00:00:44,000 --> 00:00:52,000
      time to...
      one

      2
      00:00:54,000 --> 00:00:56,000
      homebrew
      two
    EOS
    system "#{bin}/sub2srt", "#{testpath}/test.sub"
    assert_equal expected, (testpath/"test.srt").read.chomp
  end
end
