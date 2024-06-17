class Tpm < Formula
  desc "Plugin manager for tmux"
  homepage "https://github.com/tmux-plugins/tpm"
  url "https://github.com/tmux-plugins/tpm/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "2411fc416c4475d297f61078d0a03afb3a1f5322fff26a13fdb4f20d7e975570"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc7fbd2e63cf09eb0dc299caa4447a2508b76341ada7a8f2e5ad31f948aaf629"
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
