class Sub2srt < Formula
  desc "Convert subtitles from .sub to subviewer .srt format"
  homepage "https://github.com/robelix/sub2srt"
  url "https://github.com/robelix/sub2srt/archive/refs/tags/0.5.5.tar.gz"
  sha256 "169d94d1d0e946a5d57573b7b7b5883875996f802362341fe1a1a0220229b905"
  license "GPL-2.0-or-later"
  head "https://github.com/robelix/sub2srt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "ea67deb8ff20129ec22608ac25dfa2928c935552cd1d8f480c54e2247f04b9fc"
  end

  uses_from_macos "perl"

  def install
    inreplace "README", "/usr/local", HOMEBREW_PREFIX
    bin.install "sub2srt"
  end

  test do
    (testpath/"test.sub").write <<~SUB
      {1100}{1300}time to...|one
      {1350}{1400}homebrew|two
    SUB
    expected = <<~SRT
      1
      00:00:44,000 --> 00:00:52,000
      time to...
      one

      2
      00:00:54,000 --> 00:00:56,000
      homebrew
      two
    SRT
    system bin/"sub2srt", "#{testpath}/test.sub"
    assert_equal expected, (testpath/"test.srt").read.chomp
  end
end
