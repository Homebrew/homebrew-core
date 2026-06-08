class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "ea043d727660d4a10e0e851c0f44128849ac420b9fba477dad2a436b6f568173"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "870ef6c223f76183219c895a8978dfaa1a8292e34e803f602a5dee1d490aaa08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "870ef6c223f76183219c895a8978dfaa1a8292e34e803f602a5dee1d490aaa08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "870ef6c223f76183219c895a8978dfaa1a8292e34e803f602a5dee1d490aaa08"
    sha256 cellar: :any_skip_relocation, sonoma:        "870ef6c223f76183219c895a8978dfaa1a8292e34e803f602a5dee1d490aaa08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aeaca89f64b38147568e5c0473e1fc5668c18d7a7e21379d0d8de36395179fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aeaca89f64b38147568e5c0473e1fc5668c18d7a7e21379d0d8de36395179fc"
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
      r.fetch
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
