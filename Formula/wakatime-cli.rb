class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/fb/99/79972e66ae5d6a05cb76edfbe9e628b49a84f16959bd2045d14e539b8c61/wakatime-6.0.5.tar.gz"
  sha256 "f600575009d17881403c2e65a572448c8901b0dfea5ac2fa47becba905fe6a25"

  bottle do
    cellar :any_skip_relocation
    sha256 "fed6c0c8282a1c1c51a3f8a85e5a18930a6308e70ed1665fb91d47a05bfccbb5" => :el_capitan
    sha256 "c718c1551f40a37599010b17cfef2b99d9f6b514b96256ec17386eeebe83deb1" => :yosemite
    sha256 "96146e5221f2d6b3c22f4eda5fd7a3105565e995b8377b675790cc793f222f51" => :mavericks
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
