class Zplug < Formula
  desc "Next-generation plugin manager for zsh"
  homepage "https://github.com/zplug/zplug/"
  url "https://github.com/zplug/zplug/archive/refs/tags/2.4.2.tar.gz"
  sha256 "82a51e8c388844acbfb64196623bede07eee2384f1fc30966eac880373aa9030"
  license "MIT"
  head "https://github.com/zplug/zplug.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c99ea3312515bf7de844cbe43af641afebe319549ff5c8c719ccebff79810999"
  end

  uses_from_macos "zsh"

  def install
    bin.install Dir["bin/*"]
    man1.install "doc/man/man1/zplug.1"
    prefix.install Dir["*"]
    touch prefix/"packages.zsh"
  end

  def caveats
    <<~EOS
      In order to use zplug, please add the following to your .zshrc:
        export ZPLUG_HOME=#{opt_prefix}
        source $ZPLUG_HOME/init.zsh
    EOS
  end

  test do
    ENV["ZPLUG_HOME"] = opt_prefix
    system "zsh", "-c", "source #{opt_prefix}/init.zsh && (( $+functions[zplug] ))"
  end
end
