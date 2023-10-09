class Recoverpy < Formula
  include Language::Python::Virtualenv

  desc "TUI to recover overwritten or deleted data"
  homepage "https://github.com/PabloLec/recoverpy"
  url "https://files.pythonhosted.org/packages/43/1e/385e354d98b0244fabcbc6f2b240e0a940d1cd40d98ca5e9f78d0be8a6e7/recoverpy-2.1.1.tar.gz"
  sha256 "fe1527d307c87fe008b33c51cd9dea2069140df79a7664d0f6b09063e1e0fe4c"
  license "GPL-3.0-or-later"
  head "https://github.com/PabloLec/recoverpy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7980c2dcd884fa754d918ea593d43076af674178e9c31f4edb0a2bceb475fe53"
  end

  depends_on :linux
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/8d/fd/73bb30ec2b3cd952fe139a79a40ce5f5fd0280dd2cc1de94c93ea6a714d2/linkify-it-py-2.0.2.tar.gz"
    sha256 "19f3060727842c254c808e99d465c80c49d2c7306788140987a1a7a29b0d6ad2"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b4/db/61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0c/mdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/f6/77/0d0eba76ac68d08f87906a2dda06f62b761f97512f8ce434dd0dea521a6e/textual-0.38.1.tar.gz"
    sha256 "504c934c3281217a29e7a95d498aacb7fbc629f6430895f7ac51ea7ba66e5d99"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/0d/52/1284e9ed195b161261ac09bfd9785027e2734fc77360a889f6464a8e8ce8/tree_sitter-0.20.2.tar.gz"
    sha256 "0a6c06abaa55de174241a476b536173bba28241d2ea85d198d33aa8bf009f028"
  end

  # pypi artifact issue report, https://github.com/grantjenks/py-tree-sitter-languages/issues/29
  resource "tree-sitter-languages" do
    url "https://github.com/grantjenks/py-tree-sitter-languages/archive/refs/tags/v1.7.0.tar.gz"
    sha256 "1801390e30edf5ce762388ced7c376feb7e4c8262e89be100dc8cefebf604073"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/75/db/241444fe6df6970a4c18d227193cad77fab7cec55d98e296099147de017f/uc-micro-py-1.0.2.tar.gz"
    sha256 "30ae2ac9c49f39ac6dce743bd187fcd2b574b16ca095fa74cd9396795c954c54"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = fork { exec "#{bin}/recoverpy" }
  ensure
    Process.kill("TERM", pid)
  end
end
