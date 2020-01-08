class SonarCompletion < Formula
  desc "Bash completion for Sonar"
  homepage "https://github.com/a1dutch/sonarqube-bash-completion"
  url "https://github.com/a1dutch/sonarqube-bash-completion/archive/1.0.tar.gz"
  sha256 "501bb1c87fab9dd934cdc506f12e74ea21d48be72a9e4321c88187e4a0e0a99a"
  head "https://github.com/a1dutch/sonarqube-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "etc/bash_completion.d/sonar"
  end

  test do
    assert_match "-F _sonar",
      shell_output("source #{bash_completion}/sonar && complete -p sonar")
  end
end
