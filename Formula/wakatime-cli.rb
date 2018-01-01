class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/8f/b7/a575a758cf33c8c1ce0ddd642a6c26d94105ca407d68a2074e6731c878b3/wakatime-8.0.3.tar.gz"
  sha256 "bb178937a762a1250dd2e22a62ec28dc7c1ebe2dabcc9bbe05cb781afe86dd47"

  bottle do
    cellar :any_skip_relocation
    sha256 "19816456d3eecbc4cb89dd6fc247a3b91c82d783167a050b85738a90910d9a72" => :high_sierra
    sha256 "4968086ecffa2200407d844fc568e7675b20983fe6cf3a4ae683cb86ddcfde06" => :sierra
    sha256 "ee933f36da072757c1c186494b2d5f2efd93b76f76784defb4b8a5a05a1ffd70" => :el_capitan
    sha256 "ee933f36da072757c1c186494b2d5f2efd93b76f76784defb4b8a5a05a1ffd70" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
