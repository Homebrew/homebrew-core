class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/releases/download/v1.20.0/zimfw.zsh.gz"
  sha256 "b948ef89a2f6fe565197e0fa898046337168c78bfcbae43601baeb9cd51f7038"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf16c7e76fa74baed482464789109276c4af71e4a94fc6a3220716c9bbb7fafd"
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
