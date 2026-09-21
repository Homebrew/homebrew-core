class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "d730b97b7f7c9dd70310bba6fa7ce9016e62624b16099612a468e13ba7853976"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10c6bf33490d2075c13e51a56d4ed743a4ddab8b1c291d368f12e5aa01817122"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53019e028f96af647e3e6c6e3577f6939dce6042301c67abca67aba0ae50beab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53019e028f96af647e3e6c6e3577f6939dce6042301c67abca67aba0ae50beab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "53019e028f96af647e3e6c6e3577f6939dce6042301c67abca67aba0ae50beab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e99db776e413b2ebbeac4933fa5027ddf0c36a377ba7863b4ba5fe37add57cc"
    sha256 cellar: :any,                 x86_64_linux:      "a2f1360e8ad728241ff4791870b460ffa752180cb7461d888074b6309a3a5635"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/tpack"
    generate_completions_from_executable(bin/"tpack", shell_parameter_format: :cobra)
  end

  test do
    socket = testpath/"tmux.sock"
    config = testpath/"tmux.conf"
    touch config

    system "tmux", "-f", config, "-S", socket, "new-session", "-d", "-s", "tpack-test"
    system "tmux", "-S", socket, "set-environment", "-g", "TMUX_PLUGIN_MANAGER_PATH", "#{testpath}/plugins"
    system "tmux", "-S", socket, "set-option", "-g", "@tpm_plugins", "tmux-plugins/tmux-sensible"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tpack source"
    assert_match "tpack #{version}", shell_output("#{bin}/tpack --version")
  end
end
