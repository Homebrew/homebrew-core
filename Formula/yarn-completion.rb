class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.7.4.tar.gz"
  sha256 "7b91ca00c69c23518c1c0c5c93ddad23ad20b82c6f6e899e616ca53539878e42"

  bottle :unneeded

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("source #{bash_completion}/yarn && complete -p yarn")
  end
end
