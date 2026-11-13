class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/c4/9c/cadeaa5532612a66269139e4826cbbbd9c646c228ec4caf2efb0c35591d3/texttest-4.5.0.tar.gz"
  sha256 "1b8f5c4b456a6a2decb5a3e68e976768d1b37201893251ec11f332a0b1767e31"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa1007d83c48d8627d455e6299fe1da658e14dc1bec1111cb468f513be65815b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16694653bea05b57e9be062591117d97f9e968bb867a19e91b17a8d1d534a4c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76e652c0964ec5c757e15f5499b5df2f7dfea3344be4ddb6fffbcc402b5d06fb"
    sha256 cellar: :any,                 arm64_linux:       "8dd781b0a93e356034d24543e44ecd512232e5cc62c202bd486f9523a738bd4e"
    sha256 cellar: :any,                 x86_64_linux:      "1af31e2617568659a625e715f5e00cca684d145c74f775b73f60111bf423f80d"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.15"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
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
