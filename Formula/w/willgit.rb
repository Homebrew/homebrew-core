class Willgit < Formula
  desc "William's miscellaneous git tools"
  homepage "https://github.com/DanielVartanov/willgit"
  url "https://github.com/DanielVartanov/willgit/archive/refs/tags/1.0.0.tar.gz"
  sha256 "3bb99d6ec2614a90f40962311daf51f393b3d0abfdb0f9e0a14ba7340b33a2c8"
  license "MIT"
  head "https://github.com/DanielVartanov/willgit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "50393beba0d169140488b806a2b4635dbd02a81f93bddb654e367f040b57f570"
  end

  uses_from_macos "ruby"

  def install
    prefix.install "bin"
  end

  test do
    system "git", "init", "--initial-branch=main"
    (testpath/"README.md").write "# BrewTest"
    system "git", "add", "README.md"
    system "git", "commit", "-m", "init"
    assert_equal "Local branch: main", shell_output("git wtf").chomp
  end
end
