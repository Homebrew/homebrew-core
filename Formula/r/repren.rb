class Repren < Formula
  include Language::Python::Virtualenv

  desc "Rename anything using powerful regex search and replace"
  homepage "https://github.com/jlevy/repren"
  url "https://files.pythonhosted.org/packages/3c/7c/482295a3e0613df0732d69533d5f53e41f41ec86acf86bca8fd8ffa59e8e/repren-2.0.0.tar.gz"
  sha256 "5a0de4f7708ad3b86944da7c369c69a18e4d085adbb72f261aa8da13eae9bca8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c09a2852d09607acb30bb60525e255c652f6dc0cc2312f4e086884d2a3aa7364"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repren --version")

    (testpath/"test.txt").write <<~EOS
      Hello World!
      Replace Me
    EOS

    system bin/"repren", "--from", "Replace", "--to", "Modify", testpath/"test.txt"
    assert_match "Modify Me", (testpath/"test.txt").read
  end
end
