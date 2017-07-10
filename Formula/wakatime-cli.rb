class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/8f/b7/a575a758cf33c8c1ce0ddd642a6c26d94105ca407d68a2074e6731c878b3/wakatime-8.0.3.tar.gz"
  sha256 "bb178937a762a1250dd2e22a62ec28dc7c1ebe2dabcc9bbe05cb781afe86dd47"

  bottle do
    cellar :any_skip_relocation
    sha256 "49976f1234767e34befb7e9688ca62f82836168b48ed458b7293246084683e60" => :sierra
    sha256 "49976f1234767e34befb7e9688ca62f82836168b48ed458b7293246084683e60" => :el_capitan
    sha256 "49976f1234767e34befb7e9688ca62f82836168b48ed458b7293246084683e60" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
