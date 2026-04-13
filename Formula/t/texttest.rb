class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/59/56/76dde8ff62bd8cf7025d3bd9dd2a021391b4aa8e449496c2aa2c5e0a75e7/texttest-4.4.6.tar.gz"
  sha256 "ddf2210f9b774f43702d1f3204e69ec908db642d10412a55cf5f6c3f72de1f8b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436a8ff3d8efc9ce3572fa6c92a2c8fe10a0988a66fca562f9df1e2d19ac0be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9704e045db66ccbb3ba47e19e3bd6e42a1a0bb172b29d56d0c0156124fbeb2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d492f3eac297e328f7568feaeb0a1c12352abff053315dd34978edc9b9d4d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "282d47d8bcc5d9df1319d15fc4ac3cd70853fe26fdecc85614083d7b41742527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9112d710cf89b3dd3c43e6e44e4a81cdfeb52fe320775faa3b27dd3ba188e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73ee0045cb722f2d9e007b980f539caeca17e5d83ab87cfeb5a6d7e8fbfdaa8"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.14"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

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
