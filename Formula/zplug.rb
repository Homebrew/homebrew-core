class Zplug < Formula
  desc "The next-generation plugin manager for zsh"
  homepage "https://zplug.sh/"
  url "https://github.com/zplug/zplug/archive/2.2.1.tar.gz"
  sha256 "c78ea93dc5ef9f6d3b9d93f4c06bbd27940dd67068e33783f6931515a0f44f97"
  head "https://github.com/zplug/zplug.git"

  bottle :unneeded

  depends_on "zsh" => :optional

  def install
    bin.install Dir["bin/*"]
    man1.install "doc/man/man1/zplug.1"
    prefix.install Dir["*"]
    touch prefix/"packages.zsh"
  end

  def caveats; <<-EOS.undent
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
