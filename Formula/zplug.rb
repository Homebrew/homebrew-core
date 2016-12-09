class Zplug < Formula
  desc "The next-generation plugin manager for zsh"
  homepage "https://zplug.sh/"
  url "https://github.com/zplug/zplug/archive/2.3.4.tar.gz"
  sha256 "2ca4a3d1db077d19bb17d90da4b159becd08f2d308c1a7f123e6b10e4562acf5"
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
