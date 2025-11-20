class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "56dc5ca39d11bad38f7fb602ce412a0f564dc0757765ad105a2cccbe84fcd2ca"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b6e4ff4d810440e7512b14545f3f2ae267114342ef1133b537c181e0de8a636"
  end

  depends_on "ruby"
  depends_on "tmux"
  depends_on "tmuxinator-completion"

  resource "xdg" do
    url "https://rubygems.org/downloads/xdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  resource "erubi" do
    url "https://rubygems.org/downloads/erubi-1.13.1.gem"
    sha256 "a082103b0885dbc5ecf1172fede897f9ebdb745a4b97a5e8dc63953db1ee4ad9"
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

    # Make sure tmuxinator checks HOMEBREW_PREFIX for data files. Also ensures uniform bottles.
    inreplace_files = libexec.glob("gems/xdg-*/lib/xdg/base_dir{,/extended}.rb")
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    version_output = shell_output("#{bin}/tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

    commands = shell_output("#{bin}/tmuxinator commands")
    commands_list = %w[
      commands completions copy debug delete doctor
      edit implode local list new open start stop
      stop_all version
    ]

    expected_commands = commands_list.join("\n")
    assert_match expected_commands, commands

    list_output = shell_output("#{bin}/tmuxinator list")
    assert_match "tmuxinator projects:", list_output

    system bin/"tmuxinator", "new", "test"
    list_output = shell_output("#{bin}/tmuxinator list")
    assert_equal "tmuxinator projects:\ntest\n", list_output
  end
end
