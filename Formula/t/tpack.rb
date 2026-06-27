class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "840942602e9b939106f4ce437b10f711976feb4666c687133c92622f5230f164"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99406ffcf113ae7c93f07d0c997f39dab0630432c7d89fd222648ba48f877751"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99406ffcf113ae7c93f07d0c997f39dab0630432c7d89fd222648ba48f877751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99406ffcf113ae7c93f07d0c997f39dab0630432c7d89fd222648ba48f877751"
    sha256 cellar: :any_skip_relocation, sonoma:        "1597a4a1ad575da60b877957084e044e0f8654a3a83cd6439c58783d9f95a836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7156513808bceb7a2d248a4fc10106f372867a2a765eef56810bba2b1118c40"
    sha256 cellar: :any,                 x86_64_linux:  "03cd196325a244a579f3bbcad02ab33fc324e9d43319f3121e677d31d58c5cf5"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tpack"
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
