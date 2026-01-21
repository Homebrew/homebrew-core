class Tpm < Formula
  desc "Plugin manager for tmux"
  homepage "https://github.com/tmux-plugins/tpm"
  url "https://github.com/tmux-plugins/tpm/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "2411fc416c4475d297f61078d0a03afb3a1f5322fff26a13fdb4f20d7e975570"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "585e25b7dbe7d14caa7056eb0cc5f180256d8833a0e2e8fbcf01e72016b74c08"
  end

  depends_on "tmux"

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To initialize TPM add this to your tmux configuration file
      (~/.tmux.conf or $XDG_CONFIG_HOME/tmux/tmux.conf):
        run '#{opt_pkgshare}/tpm'
    EOS
  end

  test do
    assert_empty shell_output(pkgshare/"tpm")
  end
end
