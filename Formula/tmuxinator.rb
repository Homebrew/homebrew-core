class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v1.1.5.tar.gz"
  sha256 "5b445dcb62556a439d76e191fd869e7c5fa79a787c6957eda8549fa343db2eb3"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b4ae8a2bde4b3ca809b8ef0d017b4b7cfe8f9e3f0d81f5bd22c9e48cede8100" => :catalina
    sha256 "aafc33584c60390e9dc7b29c1a74a6dc55e9235d9827bbb99c067a9b8e7eadd9" => :mojave
    sha256 "1b4ae8a2bde4b3ca809b8ef0d017b4b7cfe8f9e3f0d81f5bd22c9e48cede8100" => :high_sierra
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", :because => "the tmuxinator formula includes completion"

  resource "erubis" do
    url "https://rubygems.org/downloads/erubis-2.7.0.gem"
    sha256 "63653f5174a7997f6f1d6f465fbe1494dcc4bdab1fb8e635f6216989fb1148ba"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.0.1.gem"
    sha256 "7572061e3cbe6feee57828670e6a25a66dd397f05c1f8515d49f770a7d9d70f5"
  end

  resource "xdg" do
    url "https://rubygems.org/downloads/xdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "--ignore-dependencies", "tmuxinator-#{version}.gem"
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
