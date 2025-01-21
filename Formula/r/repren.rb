class Repren < Formula
  include Language::Python::Virtualenv

  desc "Rename anything using powerful regex search and replace"
  homepage "https://github.com/jlevy/repren"
  url "https://files.pythonhosted.org/packages/7b/9e/1d5ca018f98d82e2ec958564affca79f9477f03fd11f2f9d0deca834dd6c/repren-1.0.2.tar.gz"
  sha256 "dad04db4427ca8999f7c228e9a5f3a5c26b919c7d1b26af402e0f9febdf09d93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a82077e5896eea071dea3a44430d1061df24d3d2b0b8cb72b3a6f46ab4846d8"
  end

  depends_on "python@3.13"

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
