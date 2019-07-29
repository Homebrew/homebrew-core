class Stlviewer < Formula
  desc "View stl files"
  homepage "https://github.com/vishpat/stlviewer#readme"
  url "https://github.com/vishpat/stlviewer/archive/release-0.1.tar.gz"
  sha256 "55c1969537a7c663273d0d3ab242f0bf61b93d83a7a5ea0786436a2041ecdb8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9179139d7ebb44d3eb664f1a58df0003722a76315dd7211345671ca21b7a59a1" => :mojave
    sha256 "ce4cddb8ffed5a7154be0ce328b283805fc14a1a5769c911e1492a35c1b07a1c" => :high_sierra
    sha256 "9490714ae75aaa68e9c13f9b8d3a9cd87965d09167388d768f6299067774cc69" => :sierra
    sha256 "e2b6570f4f4fa6042528212a2c0c4798ee7375855e51eaa607e737d746aa2cd0" => :el_capitan
    sha256 "7bf9c633d050993ecca2013098a3ea544bf25cdd5b5bfdff57607e887e58d0b6" => :yosemite
    sha256 "cd58c5ba32e12ebb014a809ce8bdcd4a5b85c3caaedd7063710e409a33640707" => :mavericks
  end

  def install
    system "./compile.py"
    bin.install "stlviewer"
  end

  test do
    shell_output("#{bin}/stlviewer 2>&1", 1)
  end
end
