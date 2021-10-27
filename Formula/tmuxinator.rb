class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v3.0.1.tar.gz"
  sha256 "1d79dd13beaaf2ed24c8a76410c1a41bedc7785498e199534fa3928bbf8aab01"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b641b1fedbadf9ba1baf65e9819e718ae30f486e4b1e09e24ab72da50ff28add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdd418ca1a015eb94bb192d8605d019ad4acdc69b1d7d066421ea9b0538d5003"
    sha256 cellar: :any_skip_relocation, monterey:       "8b185d024fb7ab30b4af44dc242908f1260e70c75f5b00928fa20e2ca98458ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "0735adc0586540e832e281dcbc9e43179fb89b6f50045f253a77f6914afea273"
    sha256 cellar: :any_skip_relocation, catalina:       "0735adc0586540e832e281dcbc9e43179fb89b6f50045f253a77f6914afea273"
    sha256 cellar: :any_skip_relocation, mojave:         "0735adc0586540e832e281dcbc9e43179fb89b6f50045f253a77f6914afea273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d0233e824befa21871fa4ba3578be8e30bf952ca3fe46c6155cb2f03120d174"
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

    completion = shell_output("bash -c 'source #{bash_completion}/tmuxinator && complete -p tmuxinator'")
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
