class SpringCompletion < Formula
  desc "Bash completion for Spring"
  homepage "https://github.com/jacaetevha/spring_bash_completion"
  url "https://github.com/jacaetevha/spring_bash_completion/archive/v0.0.1.tar.gz"
  sha256 "a97b256dbdaca894dfa22bd96a6705ebf4f94fa8206d05f41927f062c3dd60bf"
  license "Unlicense"
  head "https://github.com/jacaetevha/spring_bash_completion.git"

  bottle :unneeded

  def install
    bash_completion.install "spring.bash" => "spring"
  end

  test do
    assert_match "-F _spring",
      shell_output("source #{bash_completion}/spring && complete -p spring")
  end
end
