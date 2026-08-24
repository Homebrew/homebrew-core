class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "7718defcdcc69911cfad9eb2b4b0d83b68effce39fb2470e75aa023655279f9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38324696e8992c9d9bf943fa07cf8cf259502e7988c9d26a20ccedaea0a283ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38324696e8992c9d9bf943fa07cf8cf259502e7988c9d26a20ccedaea0a283ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38324696e8992c9d9bf943fa07cf8cf259502e7988c9d26a20ccedaea0a283ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d85025a9d6f97db527b029c426671dfa2594cee2d6d6e1aaab55746a387c94d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2dc3d2becdb475e2ce8a96ace8303a4062cecc1bab4aaf83e8cb60676aa2ff6"
    sha256 cellar: :any,                 x86_64_linux:  "e2876d262e8123eba8727178693e6ed4df32df667afa64f10d7de8a30e0d0778"
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
