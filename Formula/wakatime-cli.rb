class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/e3/0c/c2f8f09901003492698c5c7c7b38cc4b7c2c513a44b1c970805c33737f06/wakatime-6.2.3.tar.gz"
  sha256 "6c41f9ae1b083c761ba47ecbd7b0fd7a383584207631e125e768867063fcc8f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "910c3aa62757aee11e19c9d32793a7ae7dc5605f6b37b7cefacf7aa25915b619" => :sierra
    sha256 "910c3aa62757aee11e19c9d32793a7ae7dc5605f6b37b7cefacf7aa25915b619" => :el_capitan
    sha256 "910c3aa62757aee11e19c9d32793a7ae7dc5605f6b37b7cefacf7aa25915b619" => :yosemite
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
