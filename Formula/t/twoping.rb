class Twoping < Formula
  include Language::Python::Virtualenv

  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.6.1.tar.gz"
  sha256 "c8352b6653c3194af1f869107655df3f98ab18b560e8bce86eabac08d73c72eb"
  license "MPL-2.0"
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dffea297eab0918d416048efafdfb69f32c7d1f56b740a1455d80853b8755550"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources

    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    # Upstream removed the sample bash completion script in v4.6:
    # https://github.com/rfinnie/2ping/commit/e5f62bbc412b6f1bb14c4139a1dbcb97c32b5c81
    # Downstream guidance is tracked in:
    # https://github.com/rfinnie/2ping/issues/10
  end

  service do
    run [opt_bin/"2ping", "--listen", "--quiet"]
    keep_alive true
    require_root true
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match "OK 2PING", shell_output(
      "#{bin}/2ping --count=10 --interval=0.2 --port=-1 --interface-address=127.0.0.1 " \
      "--listen --nagios=1000,5%,1000,5% 127.0.0.1",
    )
  end
end
