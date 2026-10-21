class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/30/11/5b6c9ce24c1b23effa0db201babf7610f15a98ecf6a7c3a00fa68db7a1fe/texttest-4.4.7.tar.gz"
  sha256 "448d7f2d5c2883841df421d84b325b90067c0d385c4d6a700a6fd1cbe0972318"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7b5d1d9c00a41213dcf359f860f13b135f56eb949dd6f2d1555727e475d1a00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d61336c6ca1c2cb0ae7aa3bc107c00583f4022d269353534bd86be97f45de3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "670298760c09770543e0e0145e9819131f72dcd6acc17858fb66e825763c9f7f"
    sha256 cellar: :any,                 arm64_linux:       "5f57888bd1da6ba88f21a1c9be61909e2cd3ce47c085b69b27970cd1edc1816a"
    sha256 cellar: :any,                 x86_64_linux:      "c213279a5f9183379fb24e57e2a6747787acabd9b382e86efcd2de9ba66f95ff"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.15"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  # Fix import on Python 3.15
  patch do
    url "https://github.com/texttest/texttest/commit/f1ccd0a9dd5086f1e1e32587250aeef59e8db3b3.patch?full_index=1"
    sha256 "d7395ab06ea5ebf86bbd4c8ea0d1eaabf4f821df52116c409ae7088387978749"
    type :unofficial
    resolves "https://github.com/texttest/texttest/pull/160"
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
