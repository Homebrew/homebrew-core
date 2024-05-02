class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "d1f65fd7c27bdc35de73eee7454eb5b00b4685c8e6c6e7c163d767ab0e8920c3"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c3f00a9b3d124690b7b34f26c6d43bd91903f83382fd3a29c0e5070a1469feb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c3f00a9b3d124690b7b34f26c6d43bd91903f83382fd3a29c0e5070a1469feb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c3f00a9b3d124690b7b34f26c6d43bd91903f83382fd3a29c0e5070a1469feb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3c106948825abd2c9fcd79e5ba929ee50e2b4709cb553b41d55c129eb06f377"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c106948825abd2c9fcd79e5ba929ee50e2b4709cb553b41d55c129eb06f377"
    sha256 cellar: :any_skip_relocation, monterey:       "a3c106948825abd2c9fcd79e5ba929ee50e2b4709cb553b41d55c129eb06f377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3f00a9b3d124690b7b34f26c6d43bd91903f83382fd3a29c0e5070a1469feb"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

  resource "xdg" do
    url "https://rubygems.org/downloads/xdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.3.1.gem"
    sha256 "fa7e3471d4f6a27138e3d9c9b0d4daac9c3d7383927667ae83e9ab42ae7401ef"
  end

  resource "erubi" do
    url "https://rubygems.org/downloads/erubi-1.12.0.gem"
    sha256 "27bedb74dfb1e04ff60674975e182d8ca787f2224f2e8143268c7696f42e4723"
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
