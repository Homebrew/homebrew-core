class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/1a/b8/ac0703458d046b581df70da842de681fdcddc0fa0e5760881e18a384ec1a/wakatime-8.0.0.tar.gz"
  sha256 "d24dd8d59c91f8f1791677a4e243f56c1ed879094dc9d7e65e653e1806b31e96"

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
