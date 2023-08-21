class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v3.0.5.tar.gz"
  sha256 "f67296a0b600fb5d8e51bf8fc9f8376a887754fd74cd59b6a8d9c962ad8f80a4"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "462f888a1e5558be4225cabf5becbbb8cfe3462815b993e584b808dbfb5d9fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "462f888a1e5558be4225cabf5becbbb8cfe3462815b993e584b808dbfb5d9fc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "462f888a1e5558be4225cabf5becbbb8cfe3462815b993e584b808dbfb5d9fc5"
    sha256 cellar: :any_skip_relocation, ventura:        "3ae191a144fc61ed8f835f09f5d6792fbbfa2180d50568ad8bd625d26a527509"
    sha256 cellar: :any_skip_relocation, monterey:       "3ae191a144fc61ed8f835f09f5d6792fbbfa2180d50568ad8bd625d26a527509"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae191a144fc61ed8f835f09f5d6792fbbfa2180d50568ad8bd625d26a527509"
    sha256 cellar: :any_skip_relocation, catalina:       "3ae191a144fc61ed8f835f09f5d6792fbbfa2180d50568ad8bd625d26a527509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462f888a1e5558be4225cabf5becbbb8cfe3462815b993e584b808dbfb5d9fc5"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

  resource "erubis" do
    url "https://rubygems.org/downloads/erubis-2.7.0.gem"
    sha256 "63653f5174a7997f6f1d6f465fbe1494dcc4bdab1fb8e635f6216989fb1148ba"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.2.1.gem"
    sha256 "b1752153dc9c6b8d3fcaa665e9e1a00a3e73f28da5e238b81c404502e539d446"
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
