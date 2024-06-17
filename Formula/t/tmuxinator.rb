class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "56c0b26b37c801ba8dc95666e39bf69f4041817b34471bd915f587cface6220b"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf19c5cc5e96ce8b0186cda2a9570ed89cc6530c69746685503542346331ff01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17115c99d069a6003adb9373789aae2504f192f542d544e81cf81461f0eabb41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2471c2f41004dfe9f50b271b4f482eff56ce084d051d93d5ac4f2c6fbfbe93"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb4ea46c7355cc27e7f828dd15282916fd6a939ec869d2ba9046ccc7526fa2d1"
    sha256 cellar: :any_skip_relocation, ventura:        "115ba13675f33d4b9df9716ee915413554507ea3d30e4c545f9faf0dfc3872c3"
    sha256 cellar: :any_skip_relocation, monterey:       "86b81ad3bff4c9039086954a1a261634130c592cba0c7f21f20b81f67e6b0790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d39cde254710b088898fad72bb157b4451fc16c77be8c283a2168760a77161"
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
