class Tzdiff < Formula
  desc "Displays Timezone differences with localtime in CLI (shell script)"
  homepage "https://github.com/belgianbeer/tzdiff"
  url "https://github.com/belgianbeer/tzdiff/archive/refs/tags/1.2.1.tar.gz"
  sha256 "3438af02d6f808e9984e1746d5fd2e4bbf6e53cdb866fc0d4ded74a382d48d62"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c64a8ff4953f517e2a83959e64b6bf0fb8eb4f8d78118561686ef8940e73c798"
  end

  def install
    bin.install "tzdiff"
    man1.install "tzdiff.1"
  end

  test do
    assert_match "Asia/Tokyo", shell_output("#{bin}/tzdiff -l Tokyo")
    assert_match version.to_s, shell_output("#{bin}/tzdiff -v")
  end
end
