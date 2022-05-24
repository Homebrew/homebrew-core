class Rmate < Formula
  desc "Edit files from an SSH session in TextMate"
  homepage "https://github.com/textmate/rmate"
  url "https://github.com/textmate/rmate/archive/v1.5.8.tar.gz"
  sha256 "40be07ae251bfa47b408eb56395dd2385d8e9ea220a19efd5145593cd8cbd89c"
  license "MIT"
  head "https://github.com/textmate/rmate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f17a839cae2678598895cdbd94ecceb0197ddd0c6e94e17768a5580c3cf9cc98"
  end

  def install
    bin.install "bin/rmate"
  end

  test do
    system "#{bin}/rmate", "--version"
  end
end
