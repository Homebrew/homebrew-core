
class Testindicator < Formula
  include Language::Python::Virtualenv
  desc "Automatic test runner and indicator"
  homepage "https://github.com/logileifs/testindicator"
  url "https://github.com/logileifs/testindicator/archive/0.9.tar.gz"
  sha256 "eeba2d7aa52195ca6dfd9eeb5c6cbe1595789536c1acec6fc559c073609d2b2f"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/54/7d/c7c0ad1e32b9f132075967fc353a244eb2b375a3d2f5b0ce612fd96e107e/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  resource "pyyaml" do
    url "htts//files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "zenipy" do
    url "https://files.pythonhosted.org/packages/ef/61/487ab8bc891a3d1d5b95c1ab4aab82c6cd4720e8a4cd2b0ece1e9e4a99a6/zenipy-0.1.4.tar.gz"
    sha256 "ee85a921be198ee07c17741acb348478382a2ceb135c54907dd027ae4be527a0"
  end

  resource "pync" do
    url "https://files.pythonhosted.org/packages/01/69/04dbd2ddf85a24faf116821e89bb188e1c7c666e8803ba7a08dc7783ae11/pync-1.6.1.tar.gz"
    sha256 "85737aab9fc69cf59dc9fe831adbe94ac224944c05e297c98de3c2413f253530"
  end

  resource "argh" do
    url "https://files.pythonhosted.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "pathtools" do
    url "https://files.pythonhosted.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/testindicator"
  end
end
