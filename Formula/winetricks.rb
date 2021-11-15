class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20210825.tar.gz"
  sha256 "bac77918ef4d58c6465a1043fd996d09c3ee2c5a07f56ed089c4c65a71881277"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "322c2e6e1dd72073bfb03a230820eb039592c016103d0c442739e9f6c9f3470b"
  end

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
