class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/ea/02/7eabb94699fd4c2209e2405eafe693ba53e48eddb99c926ed1d641b1243c/wakatime-6.2.1.tar.gz"
  sha256 "ad12fd298b0eb03148230f7a82395d406a5c8d50c32477b6ebe323194e189e4e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7348a29398d45c12a4b1010e25be99943bdeb17cac9a3f6bfa3e1d6be33c0cb3" => :sierra
    sha256 "faf9db9fc94fe49460be625fcac7a0c7e8bc137d1ac59f7b50e9323fe5e055ce" => :el_capitan
    sha256 "faf9db9fc94fe49460be625fcac7a0c7e8bc137d1ac59f7b50e9323fe5e055ce" => :yosemite
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
