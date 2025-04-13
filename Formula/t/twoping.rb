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
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "5153c17a69826ba8fa3274c858acc3c608cf7b9208fa683043fcda9bed6311c1"
  end

  depends_on "python@3.13"

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
