class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/d2/52/762474c7ec7b36b2dbc5f4494137dc9ec31129aa482107a7a619dae6d78a/rpl-1.16.1.tar.gz"
  sha256 "5539b8294e7d624e74d6d51d567e33ddb171f4eb74d020cbf471a57f8e3fb78e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f2688bbf2f3c0992730e9e74e951a16a90fc363e395928205e92b6b654eec9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3bde49799ea9c9df361f7906b77ced1024a65ee48cb0ae86e95c851959ae1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c198651e00d89a8dc1b5a9a0a44519f69c16d09c27b052682f5833003e66e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "be1ebeb43eb88d18eab4598f38c27ac768ad35885eaf3238b7d8d18b235f1ed5"
    sha256 cellar: :any_skip_relocation, ventura:       "24b4f7e1a0f50a9cddbc61a5fe831bd5aa1b5c74213e5ae70dd5942143d4acce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690ee22d68487bc065efa26e1e92df9c1f963d6d1beb8b438fce6d56ef84b887"
  end

  depends_on "python@3.13"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/a5/cc/93357fd1f53c61fdc6111a6d9ea2cc565b2c1be9227c15bb036a0db0396b/chainstream-1.0.2.tar.gz"
    sha256 "b32975d3b3d1c030a507ac298044c28fa3ca30d527abdfae281edd53276617b3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
