class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/releases/download/v1.18.0/zimfw.zsh.gz"
  sha256 "ec1a6a5b89fa1ab9262c6614f8fb14432483817e9a572608791a861995f15c46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da833b86e814243b438d819009dcf738fd6f7ef8fa2dc18fd0107e648cccacd0"
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
