class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/ab/13/a5b7ebe78f3ec4a3d029777713fa2ba84a6bdcd49b9d0a6ae75f76b268ea/wakatime-7.0.4.tar.gz"
  sha256 "d5a700bb9cfb299affaa9293964c481ce8a1235abe8c5cbec80fcfccf567434c"

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
