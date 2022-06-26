class Willgit < Formula
  desc "William's miscellaneous git tools"
  homepage "https://github.com/DanielVartanov/willgit"
  url "https://github.com/DanielVartanov/willgit/archive/1.0.0.tar.gz"
  sha256 "3bb99d6ec2614a90f40962311daf51f393b3d0abfdb0f9e0a14ba7340b33a2c8"
  license "MIT"
  head "https://github.com/DanielVartanov/willgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "471907584cfb2691323566ad760ea0686de7aac0e2f20edc2ad0575146caee83"
  end

  conflicts_with "git-utils",
    because: "both install a `git-rank-contributors` script"

  def install
    prefix.install "bin"
  end

  test do
    system "git", "init"
    (testpath/"README.md").write "# My Awesome Project"
    system "git", "add", "README.md"
    system "git", "commit", "-m", "init"
    assert_equal "Local branch: master",
      shell_output("git wtf").chomp
  end
end
