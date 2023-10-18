class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.5.1.tar.gz"
  sha256 "b56beb1b7da1ab23faa6d28462bcab9785021011b3df004d5d3c8a97ed7d70d8"
  license "MPL-2.0"
  revision 1
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "75e4fc4ecab8c1c779214c4220d5d7c0c61b3d6a2d9f64774a12950cf22bcfe0"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, *Language::Python.setup_install_args(libexec, python3)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
