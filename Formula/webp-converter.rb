class WebpConverter < Formula
  desc "Converter PNG/JPG to Webp and analytics all changes"
  homepage "https://github.com/Jacksgong/webp-converter"
  url "https://github.com/Jacksgong/webp-converter/archive/v4.0.1.tar.gz"
  sha256 "4be6d5f6cb2e70779c3c6ad114d1d2e30c96d9682d85f3892e444c6cc197b39c"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "webp" => :run

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/webpc", "--help"
  end
end
