class Rmate < Formula
  desc "Edit files from an SSH session in TextMate"
  homepage "https://github.com/textmate/rmate"
  url "https://github.com/textmate/rmate/archive/v1.5.8.tar.gz"
  sha256 "40be07ae251bfa47b408eb56395dd2385d8e9ea220a19efd5145593cd8cbd89c"
  license "MIT"
  head "https://github.com/textmate/rmate.git"

  bottle :unneeded

  def install
    bin.install "bin/rmate"
  end

  test do
    system "#{bin}/rmate", "--version"
  end
end
