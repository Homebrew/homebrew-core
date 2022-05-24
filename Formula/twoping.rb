class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.5.1.tar.gz"
  sha256 "b56beb1b7da1ab23faa6d28462bcab9785021011b3df004d5d3c8a97ed7d70d8"
  license "MPL-2.0"
  revision 1
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1847c704c33620ee0aa48c1c9d9dd7cbe5adad99acbbe440daecc8ad8b1444d"
  end

  depends_on "python@3.10"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
    bash_completion.install "2ping.bash_completion" => "2ping"
  end

  plist_options startup: true
  service do
    run [opt_bin/"2ping", "--listen", "--quiet"]
    keep_alive true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match "OK 2PING", shell_output(
      "#{bin}/2ping --count=10 --interval=0.2 --port=-1 --interface-address=127.0.0.1 "\
      "--listen --nagios=1000,5%,1000,5% 127.0.0.1",
    )
  end
end
