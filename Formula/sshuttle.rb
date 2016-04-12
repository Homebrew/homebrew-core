class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://pypi.python.org/packages/source/s/sshuttle/sshuttle-0.78.0.tar.gz"
  sha256 "6bd80d48f73eb04d4449a8aa636081704107cfdef05980b3b02166ff44e419a2"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/sshuttle -h"
  end
end
