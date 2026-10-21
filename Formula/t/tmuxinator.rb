class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "5abf32ddd6cb22fac7991310024bc14d95820e09cb7d86c6b633210afd549f67"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d67f07267922500c3c0a8d001a153d134aa795f145bfa2f0483ac996f6f128ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d67f07267922500c3c0a8d001a153d134aa795f145bfa2f0483ac996f6f128ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d67f07267922500c3c0a8d001a153d134aa795f145bfa2f0483ac996f6f128ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e27bc711dbc5d7f3d159307c17874c2baaac85bdf1bfac2a4b618e6eccab85b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e27bc711dbc5d7f3d159307c17874c2baaac85bdf1bfac2a4b618e6eccab85b9"
  end

  depends_on "ruby"
  depends_on "tmux"
  depends_on "tmuxinator-completion"

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
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "--ignore-dependencies", "tmuxinator-#{version}.gem"
    bin.install libexec/"bin/tmuxinator"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    version_output = shell_output("#{bin}/tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

    commands = shell_output("#{bin}/tmuxinator commands")
    commands_list = %w[
      commands completions copy debug delete doctor
      edit help implode local list new open start stop
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
