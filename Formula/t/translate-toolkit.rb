class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/8e/5a/5c7fc1aca6c2db12379a9a511682dd58ac64bc505792bd84ff1995d594e9/translate_toolkit-3.16.2.tar.gz"
  sha256 "eb63bef9d9aa49901cfa327061694d8cf048d0877198792a9ac6ab1a78828175"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "423aa8680b80c45fb5d067ecb8bd731226c5dc39dea1f3d1a0fba2af597e3629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36b57592c7c6f0a30e80f802575bd2cdc24646db56e7932bd2f3445b42d26b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f49e0d0dd647f073a1edf90780bb8f472724c6a287c54cd3a643f2ac89350d"
    sha256 cellar: :any_skip_relocation, sonoma:        "07055224ca7b14e158a7caa1eb9ce60ababf8b7c2afebdef2096787606f028bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4cc7f332bf59afc613378034583a645c177224e3819acbedafbf5dfeee0b785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0fed9ed22dd2f012f58ac8e52e33b5b64a7a7e946dc5e958ad21adc8474ddf"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
