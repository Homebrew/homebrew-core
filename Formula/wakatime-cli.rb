class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://files.pythonhosted.org/packages/87/03/1e919ddff6488a9be5e609ee3de500bf17b0151734d57c8923c605246235/wakatime-13.1.0.tar.gz"
  sha256 "8da2e38335a60819b61adb60a72adc6588b3755eca376d05c9588cbf5fe64c57"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d275f57a3ac6975be6b3fb65ab6d788b767c9c7bfc4c6471b61881b14f858586" => :catalina
    sha256 "391196df0c849c90c8fad31b1c7fe29668cc4999fc3805ff54770c01820dfd5a" => :mojave
    sha256 "e8ec76f4f302361f95d2a462f88fd12687e036da8cc6acee381499cbaf196b50" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_match "Common interface for the WakaTime api.", shell_output("#{bin}/wakatime --help 2>&1")

    assert_match "error: Missing api key.", shell_output("#{bin}/wakatime --project test 2>&1", 104)
  end
end
