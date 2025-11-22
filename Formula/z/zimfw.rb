class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/releases/download/v1.19.1/zimfw.zsh.gz"
  sha256 "73a1cdc8c025994942a4a4827a47a4740f97903b37b74abf558206f8da387fa6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b7050f7a58f6883601057c2be5472fa3bc8d5caa7158247229a785a503fc598"
  end

  uses_from_macos "zsh" => :test

  def install
    share.install "zimfw.zsh"
  end

  def caveats
    <<~EOS
      zimfw.zsh lives in #{opt_share}/zimfw.zsh to source in your .zshrc.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh version'")

    (testpath/".zimrc").write("zmodule test --use mkdir --on-pull '>init.zsh <<<\"print test\"'")
    system "zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh init -q'"
    assert_path_exists testpath/".zim/modules/test/init.zsh"
    assert_path_exists testpath/".zim/init.zsh"
  end
end
