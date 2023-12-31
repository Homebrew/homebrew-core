class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/7b/14/e52c96906f1d397c776c4940f68e9b44cae6b1a1aaba915c372638c3b48f/TextTest-4.3.1.tar.gz"
  sha256 "8c228914dbedbea291c3867c844bf32487306ada2a2cb2e3b228427da37bc7cb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "356098cb25f79a7e9af7bf4b6a2b8480f6affa1ff13e8c863c24313f2060fe0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a6a3c22805677216e4abdd709461ef81ff8ef2d2ee792630ee9b150f32de780"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f77d2351320d6bb33e59ef67b772b37d1bd589cfcfb928e7f38944af2671690"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f6bd92d9241fadc56fbd829e37927c7b5a12b1e15b2c276366425c300e3d2bc"
    sha256 cellar: :any_skip_relocation, ventura:        "836a0421a967bf3464adce4d8be9faee8d175a9e62cca8a6f1336d07070b3173"
    sha256 cellar: :any_skip_relocation, monterey:       "2eae1663be9f971f0d729ff0ee91ed9e0c5e6d7b4b85900f90192de5f7216e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fd474b7f1c1090b9d06a302ac520c82c0f78f5431606ac4eca3f9920956e5c"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python-psutil"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
