class Twoping < Formula
  include Language::Python::Virtualenv

  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.5.1.tar.gz"
  sha256 "b56beb1b7da1ab23faa6d28462bcab9785021011b3df004d5d3c8a97ed7d70d8"
  license "MPL-2.0"
  revision 1
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef33ac789c154cbf0eba01c1af9e4c31d9a491258ae97bb15b4686ff600104ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef33ac789c154cbf0eba01c1af9e4c31d9a491258ae97bb15b4686ff600104ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef33ac789c154cbf0eba01c1af9e4c31d9a491258ae97bb15b4686ff600104ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef33ac789c154cbf0eba01c1af9e4c31d9a491258ae97bb15b4686ff600104ee"
    sha256 cellar: :any_skip_relocation, ventura:        "ef33ac789c154cbf0eba01c1af9e4c31d9a491258ae97bb15b4686ff600104ee"
    sha256 cellar: :any_skip_relocation, monterey:       "ef33ac789c154cbf0eba01c1af9e4c31d9a491258ae97bb15b4686ff600104ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafa2c41be4f9c5d9a83d80f83fd81560da9e1edfafe157ef010781be9afc083"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bash_completion.install "2ping.bash_completion" => "2ping"
  end

  service do
    run [opt_bin/"2ping", "--listen", "--quiet"]
    keep_alive true
    require_root true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match "OK 2PING", shell_output(
      "#{bin}/2ping --count=10 --interval=0.2 --port=-1 --interface-address=127.0.0.1 " \
      "--listen --nagios=1000,5%,1000,5% 127.0.0.1",
    )
  end
end
