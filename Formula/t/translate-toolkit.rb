class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/5f/26/200ba39b505d8b0a7d4e072e6aa84a4d757fae8c00e5e3a2f2ccba2ab198/translate_toolkit-3.16.3.tar.gz"
  sha256 "d9656526a8bb0f0a88a16a08ed463036589cd34af059daf80aaaa90b9246586c"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc608977f3ea337455cfb4932078a376cdcef70dc16b862baead4dd2ab83c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11578cc5be114ea0621d675d80e51b1ad601839e18d495c07b93cfa3a9d99a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2accc8375061e61e70e20d557eaaa80c53c462d9e6ba02e155a3b73a66d8db"
    sha256 cellar: :any_skip_relocation, sonoma:        "196a5adaa4464d58b76dc693bae24168a72e887eb8180c59cf45f6f7bbe09f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070b5d84232a016ba5bc6ac31649ab4bbdef60f4fb7401121d6f5b304d7bc410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bb091b1aa68b6020f3a03ca09b05a77b1dc118935be5504b7dbc5a2f5f92d4"
  end

  depends_on "python@3.14"

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
