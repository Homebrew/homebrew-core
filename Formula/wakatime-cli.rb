class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://files.pythonhosted.org/packages/04/db/9917533f8fd503f636f8c5655d9055f2fbef6f90a12a0210b92994f6f823/wakatime-10.4.1.tar.gz"
  sha256 "8acef3ab83dbf9b5cc7592510b9dea1b75f20f4bdf60650329431b81e7f125a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "2385158d3ea9cac306f4f5941b8d5e5567a48812d81754c48fed8f68d1eb52f9" => :mojave
    sha256 "19816456d3eecbc4cb89dd6fc247a3b91c82d783167a050b85738a90910d9a72" => :high_sierra
    sha256 "4968086ecffa2200407d844fc568e7675b20983fe6cf3a4ae683cb86ddcfde06" => :sierra
    sha256 "ee933f36da072757c1c186494b2d5f2efd93b76f76784defb4b8a5a05a1ffd70" => :el_capitan
    sha256 "ee933f36da072757c1c186494b2d5f2efd93b76f76784defb4b8a5a05a1ffd70" => :yosemite
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
