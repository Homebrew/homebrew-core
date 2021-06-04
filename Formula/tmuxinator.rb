class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v2.0.3.tar.gz"
  sha256 "7ef03f8b23306944170b5951e7db280d1a1c3f1484fc292056f28185224634ab"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62ff7ec6746d01cf90d68ac56a4550e9ed00162ae3625528e433940143b06131"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6c77802104e9e397dbd796667b7ef78e296a7b243bfd885ce395c648847f321"
    sha256 cellar: :any_skip_relocation, catalina:      "515f228bfc6d511abf6d5e52a54a1fe006deb6d3d31ab53774c4ce650f91b41c"
    sha256 cellar: :any_skip_relocation, mojave:        "b3ea4285613f2367e7f75fb1f47e4c370dd1159d99531d19c38f8a80b23e459f"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

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
