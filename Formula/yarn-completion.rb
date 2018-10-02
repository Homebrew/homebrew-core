class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  depends_on "bash-completion@2"
  url "https://github.com/dsifford/yarn-completion/archive/v0.9.0.tar.gz"
  sha256 "b28fb51d5417a78b9e18c947e87dafd602de620e80360741ff0183dcf1e9c701"
  
  bottle :unneeded

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("source #{bash_completion}/yarn && complete -p yarn")
  end
end
