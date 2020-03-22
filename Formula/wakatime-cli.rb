class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://files.pythonhosted.org/packages/0f/45/4d3bd56a3840d384ee0a24270658d139780ceb5a2f3e7aa3cb10d5e46360/wakatime-13.0.7.tar.gz"
  sha256 "07a6d07e1227e3bd45242a2a4861d105bddc6220174a9b739c551bd2d45ce0fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "6415adc12bbcea7ae69fa5ca29848dac754e9f09cc0f21a2c246d4118e8aa90a" => :catalina
    sha256 "6415adc12bbcea7ae69fa5ca29848dac754e9f09cc0f21a2c246d4118e8aa90a" => :mojave
    sha256 "6415adc12bbcea7ae69fa5ca29848dac754e9f09cc0f21a2c246d4118e8aa90a" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Common interface for the WakaTime api.", shell_output("#{bin}/wakatime --help 2>&1")

    assert_match "error: Missing api key.", shell_output("#{bin}/wakatime --project test 2>&1", 104)
  end
end
