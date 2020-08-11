class Scspell < Formula
  desc "Spell checker for source code"
  homepage "https://pypi.python.org/pypi/scspell3k"
  url "https://github.com/myint/scspell/archive/v2.2.tar.gz"
  sha256 "04c6a795a9e0ef4571678eb9fc503bcf39106a975691336af778f31a01027082"
  license "GPL-2.0-only"

  depends_on "python@3.7"

  def install
    system "#{Formula["python@3.7"].opt_bin}/python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test scspell`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/scspell", "-h"
  end
end
