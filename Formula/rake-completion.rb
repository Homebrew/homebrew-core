class RakeCompletion < Formula
  desc "Bash completion for Rake"
  homepage "https://github.com/JoeNyland/rake-completion"
  url "https://github.com/JoeNyland/rake-completion/archive/v1.0.0.tar.gz"
  sha256 "2d619d0d1d8052994011209c62f926b9e41d45e9268da4b9858fa45911b04cd1"

  bottle :unneeded

  def install
    bash_completion.install "rake.sh" => "rake"
  end

  test do
    assert_match "-F _rakecomplete",
      shell_output("source #{bash_completion}/rake && complete -p rake")
  end
end
