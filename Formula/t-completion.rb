class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t/archive/v3.1.0.tar.gz"
  sha256 "900ef6e3d6180b70bf2434503774ea5e1bf985b9110d4f051c44a191b08f6062"
  head "https://github.com/sferik/t.git"

  bottle :unneeded

  def install
    bash_completion.install "etc/t-completion.sh" => "t"
    zsh_completion.install "etc/t-completion.zsh" => "_t"
  end

  test do
    assert_match "-F _t",
      shell_output("source #{bash_completion}/t && complete -p t")
  end
end
