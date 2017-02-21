class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/85/5e/22331f631f33385073aaeabc2202db1e9e9371574ad720005d2ded8c2272/wakatime-7.0.2.tar.gz"
  sha256 "ba02e12ccd12908eae290dcb97e55104e4ee7aca6fbad77209e57a89bdc01857"

  bottle do
    cellar :any_skip_relocation
    sha256 "972154f7c4c27e50cb7c5a09bf10c6e8a79ac9ffe0d43e777bd4bb88f201f353" => :sierra
    sha256 "972154f7c4c27e50cb7c5a09bf10c6e8a79ac9ffe0d43e777bd4bb88f201f353" => :el_capitan
    sha256 "972154f7c4c27e50cb7c5a09bf10c6e8a79ac9ffe0d43e777bd4bb88f201f353" => :yosemite
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
