class WebpConverter < Formula
  desc "Converter PNG/JPG to Webp and analytics all changes"
  homepage "https://github.com/Jacksgong/webp-converter"
  url "https://github.com/Jacksgong/webp-converter/archive/v4.0.0.tar.gz"
  sha256 "481fc8d8a76b810e783dd8febbc4f88e4648c56e81af1cc6bda80d89c7e8f776"

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
