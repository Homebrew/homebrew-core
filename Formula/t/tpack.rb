class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "c3d7937421c09bc7f746facb0d484c1ba23897e8fd9ddb8e92e795fcc03b19be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db5abb348c763c4c00589b280dad6d927375d85291b81cb203e100f5bfb0e0a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db5abb348c763c4c00589b280dad6d927375d85291b81cb203e100f5bfb0e0a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db5abb348c763c4c00589b280dad6d927375d85291b81cb203e100f5bfb0e0a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69a0edbf6b193dc33d3b1cb56edcb82d50b387fbd45ee272d85d1778624d14d6"
    sha256 cellar: :any,                 x86_64_linux:      "06ce291852f17b88ceaa22cc6335406f364f2adc807a7f66e726628c5174f5b4"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
