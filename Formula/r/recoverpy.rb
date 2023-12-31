class Recoverpy < Formula
  include Language::Python::Virtualenv

  desc "TUI to recover overwritten or deleted data"
  homepage "https://github.com/PabloLec/recoverpy"
  url "https://files.pythonhosted.org/packages/88/67/7ef7dc81c4be47620adc83b232b7a0ffd992ec312e087bc1f633a0961b1a/recoverpy-2.1.5.tar.gz"
  sha256 "9a2a831e9945585a54ce968d877dc81983d8228cc2b5c2fbacfff5480d09a393"
  license "GPL-3.0-or-later"
  head "https://github.com/PabloLec/recoverpy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ffd3e7f98f355a93f02e4d7aee90124cfa556bb5a970d84bd0505ca83b7207a7"
  end

  depends_on :linux
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/db/5a/392426ddb5edfebfcb232ab7a47e4a827aa1d5b5267a5c20c448615feaa9/importlib_metadata-7.0.0.tar.gz"
    sha256 "7fc841f8b8332803464e5dc1c63a2e59121f46ca186c0e2e182e80bf8c1319f7"
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
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/b4/a9/52c9df627286193fd4fd90f779cf53a2eb332bf0ceb8df2f154add9c1f7b/textual-0.45.1.tar.gz"
    sha256 "1a6f80fb87e40a0490cf9a16526f5418a790d9c032a2983b0c7edd1c8abf39f3"
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
    pid = fork { exec bin/"recoverpy" }
    sleep 2
  ensure
    Process.kill("TERM", pid)
  end
end
