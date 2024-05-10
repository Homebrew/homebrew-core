class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/54/f1/9019d19f844d0206ed671dcbfd6a8c9020af25bb021fcc861ce66d3d4e0a/translate_toolkit-3.13.0.tar.gz"
  sha256 "d31a1191894d0ad4ed99697663f1462e9a1820af3bbcf6848235add20cc00e62"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f92be498a69dd91fd954ddd1765e5d7a9046a1c6f1d57676795a895b92873df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6bacf92f41742f22a59cbdba16b190d01909f7442de25a0ebbd180d34b90e7a"
    sha256 cellar: :any,                 arm64_monterey: "ec99c46119d603f3965343dce4fe7ff3279a898840d91288d86e83bfafc71553"
    sha256 cellar: :any_skip_relocation, sonoma:         "22f3d2c282d8db6de8b18eadacc1f19f0c2b18c8da12b95760375f72e1674eea"
    sha256 cellar: :any_skip_relocation, ventura:        "70b1863e050d5c310277e8a909011bbdc743b1954332d1459a92e10c4a42f11e"
    sha256 cellar: :any,                 monterey:       "c56a54251dfde0c818ac0a6a92017015b25fb766f0570ff3eca28f094aa97188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd4ddcd10de08244104e093aba34d6da26e95983828aae80bcb096388f48673"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
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
