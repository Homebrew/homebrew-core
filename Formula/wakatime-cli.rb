class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/94/aa/c0/37c51b21d6b133742beb9a5a53495f4d7c096bb12d1da77f17/wakatime-6.2.1.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

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
