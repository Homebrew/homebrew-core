class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "f173d3481f01ad6321e639fa07473715c5f2210dad4b073bd0d1d87087f80785"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9712fe213b31d38a7f6e0ff3065004a9b8841b4ad0560357a62ecef0540669f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9712fe213b31d38a7f6e0ff3065004a9b8841b4ad0560357a62ecef0540669f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9712fe213b31d38a7f6e0ff3065004a9b8841b4ad0560357a62ecef0540669f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e18a834507459d648abcedaa12a0301be4e0054d0d1e7d67872210f313355fa1"
    sha256 cellar: :any_skip_relocation, ventura:        "e18a834507459d648abcedaa12a0301be4e0054d0d1e7d67872210f313355fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "e18a834507459d648abcedaa12a0301be4e0054d0d1e7d67872210f313355fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9712fe213b31d38a7f6e0ff3065004a9b8841b4ad0560357a62ecef0540669f"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

  resource "erubis" do
    url "https://rubygems.org/downloads/erubis-2.7.0.gem"
    sha256 "63653f5174a7997f6f1d6f465fbe1494dcc4bdab1fb8e635f6216989fb1148ba"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.3.0.gem"
    sha256 "1adc7f9e5b3655a68c71393fee8bd0ad088d14ee8e83a0b73726f23cbb3ca7c3"
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
