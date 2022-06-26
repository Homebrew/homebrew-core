class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/65/6c/f51ba2fbc74916f4fe3883228450306135e13be6dcca03a08d3e91239992/s3cmd-2.2.0.tar.gz"
  sha256 "2a7d2afe09ce5aa9f2ce925b68c6e0c1903dd8d4e4a591cd7047da8e983a99c3"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf33ae13c4d9e22ae99b8508db8377c08abf789a3438efd2f768367469111fa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0524e011b71b57afc8276cd1df26de6550caf1fddf507abfec590f0f6769dba2"
    sha256 cellar: :any_skip_relocation, monterey:       "346540c7c9d5898e157df02dfa7b84aef3edd094a06929ca9df7d02a1c4ca9d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "40be72f6f518aae27bf420abcdb17d04261858b7f66ec58afd89eb56fe03d541"
    sha256 cellar: :any_skip_relocation, catalina:       "9370607e3fb43d8a466b0daa7c2f4292c6640fa66a4fcfc2802f5980c11712f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0afba47e264b4a94fc0b6b96f69880d51e3cdf126998f7fd3b1079f149587adb"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/f7/46/fecfd32c126d26c8dd5287095cad01356ec0a761205f0b9255998bff96d1/python-magic-0.4.25.tar.gz"
    sha256 "21f5f542aa0330f5c8a64442528542f6215c8e18d2466b399b0d9d39356d83fc"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
