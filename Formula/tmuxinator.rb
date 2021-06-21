class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v3.0.1.tar.gz"
  sha256 "1d79dd13beaaf2ed24c8a76410c1a41bedc7785498e199534fa3928bbf8aab01"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c50a6bf3415ca64b624e008c1fc53ef24184816a18db526d3ca9310f2880f067"
    sha256 cellar: :any_skip_relocation, big_sur:       "58d4d39283b202c9bba67eaa8d58dc48e2f7654caa7806273d25e757eb1e25f0"
    sha256 cellar: :any_skip_relocation, catalina:      "58d4d39283b202c9bba67eaa8d58dc48e2f7654caa7806273d25e757eb1e25f0"
    sha256 cellar: :any_skip_relocation, mojave:        "58d4d39283b202c9bba67eaa8d58dc48e2f7654caa7806273d25e757eb1e25f0"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

  resource "erubis" do
    url "https://rubygems.org/downloads/erubis-2.7.0.gem"
    sha256 "63653f5174a7997f6f1d6f465fbe1494dcc4bdab1fb8e635f6216989fb1148ba"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.1.0.gem"
    sha256 "cacae12a3761be4ccbe63be19261352b108f86c721c37d87664328efeaa6d0a3"
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
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

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
