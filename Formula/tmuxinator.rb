class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v0.15.0.tar.gz"
  sha256 "e5c121126aebe3afc758c0561b8ef05508712a799d3821453063b87445806ed4"
  depends_on "tmux"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "tmuxinator-#{version}.gem"
    bin.install libexec/"bin/tmuxinator"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])

    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    version_output = shell_output("#{bin}/tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

    completion = shell_output("source #{bash_completion}/tmuxinator && complete -p tmuxinator")
    assert_match "-F _tmuxinator", completion

    commands = shell_output("#{bin}/tmuxinator commands")
    commands_list = %w[
      commands completions new edit open start
      stop local debug copy delete implode
      version doctor list
    ]

    expected_commands = commands_list.join("\n")
    assert_match expected_commands, commands

    list_output = shell_output("#{bin}/tmuxinator list")
    assert_match "tmuxinator projects:", list_output

    system "#{bin}/tmuxinator", "new", "test"
    list_output = shell_output("#{bin}/tmuxinator list")
    assert_equal "tmuxinator projects:\ntest\n", list_output
  end
end
