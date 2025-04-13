class Tmpmail < Formula
  desc "Temporary email right from your terminal written in POSIX sh"
  homepage "https://github.com/sdushantha/tmpmail"
  url "https://github.com/sdushantha/tmpmail/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "8d12f5474b89ee585413ec32cc9991a971a00e8bb63ac8e5a2e736f734f37cfb"
  license "MIT"
  head "https://github.com/sdushantha/tmpmail.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81e6aa8ea9a04b09f48bde663f58eb155061f1f83f8647727371a72cafaf9c0d"
  end

  depends_on "jq"
  depends_on "w3m"
  depends_on "xclip"

  def install
    bin.install "tmpmail"
    man1.install "tmpmail.1"
  end

  test do
    system bin/"tmpmail", "--generate"

    assert_match version.to_s, shell_output("#{bin}/tmpmail --version")
  end
end
