class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "390037134af0ce6861310ddecb912565228499efa49c2c1b352ea24786434e41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48e1697ee2fb7b34476b78e4341f252056941c87103bfa42278f538d1842785f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e1697ee2fb7b34476b78e4341f252056941c87103bfa42278f538d1842785f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e1697ee2fb7b34476b78e4341f252056941c87103bfa42278f538d1842785f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d02b96552cd7bb5517dcc6722619f7ceec69a407170a8a19709cafb7dc35db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b88c37273ba35849ecd90db65dc2a7be88545df2f7ca7ff025e3c1a3ed960272"
    sha256 cellar: :any,                 x86_64_linux:  "61822ba9a6344173ad3a6763c5cd91d1b114216f8c1dca37af94b830962ca442"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tpack"
    generate_completions_from_executable(bin/"tpack", shell_parameter_format: :cobra)
  end

  test do
    socket = testpath/"tmux.sock"
    system "tmux", "-f", File::NULL, "-S", socket, "new-session", "-d", "-s", "tpack-test"
    system "tmux", "-S", socket, "set-environment", "-g", "TMUX_PLUGIN_MANAGER_PATH", "#{testpath}/plugins"
    system "tmux", "-S", socket, "set-option", "-g", "@tpm_plugins", "tmux-plugins/tmux-sensible"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tpack source"
    assert_match "tpack #{version}", shell_output("#{bin}/tpack --version")
  end
end
