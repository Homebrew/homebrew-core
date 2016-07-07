class XdebugOsx < Formula
  desc "Simple bash script to toggle xdebug on/off in OSX"
  homepage "https://github.com/w00fz/xdebug-osx"
  url "https://github.com/w00fz/xdebug-osx/archive/1.0.tar.gz"
  sha256 "42b4f06422838083efa9bfe1d545f369802ba62c224c4cb54694e40dc1966725"

  bottle do
    cellar :any_skip_relocation
    sha256 "b97aaaf19fee69734b4a29e22c498becaa94b3025a192a7ef8f1ecfb0a2ce87c" => :el_capitan
    sha256 "5c01278c495e8a67b7af02f6355ac6a79ce6b4caa5148503346eb33e7d26b70a" => :yosemite
    sha256 "9bf1cb0bf030d70bb37a311b92621747d02379cb7f6ae6734bcb4239bdb9d4e6" => :mavericks
  end

  def install
    bin.install "xdebug"
  end

  def caveats; <<-EOS.undent
    Only for PHP and Xdebug installed via Homebrew!

    Usage:
      xdebug       # outputs the current status
      xdebug on    # enables xdebug
      xdebug off   # disables xdebug
    EOS
  end

  test do
    system "#{bin}/xdebug"
  end
end
