class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.8.0.tar.gz"
  sha256 "f359dbfd4d9dd28e231e81da16f308e73662fd586546672569a0eac994f2bcd6"

  bottle :unneeded

  depends_on "yarn"

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("source #{bash_completion}/yarn && complete -p yarn")
  end
end
