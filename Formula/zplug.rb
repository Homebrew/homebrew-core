class Zplug < Formula
  desc "The next-generation plugin manager for zsh"
  homepage "https://zplug.sh/"
  url "https://github.com/zplug/zplug/archive/2.3.2.tar.gz"
  sha256 "ce7083915eb715841ed0a6e2bc0ab84aec69b49d461511bf6496fc06bc79e45c"
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
