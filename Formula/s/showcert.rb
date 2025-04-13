class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/73/3b/c12cf95dee088c8edfa5ae6ccff5866f2e8e179b5c7bb482282a3da967a7/showcert-0.3.3.tar.gz"
  sha256 "bad2e4dacccc3cc448989249b433fd8e7072a31a53b07d0ea052fea8082bf483"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d679947d8db84b21361a246b5cc297cb12d6be781b10a6fdd2b240dd576a7689"
    sha256 cellar: :any_skip_relocation, ventura:       "d679947d8db84b21361a246b5cc297cb12d6be781b10a6fdd2b240dd576a7689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d74b7b5d28fc85eab96106abcd9b4c163bda93abec72f2a6d0a3b6c0714015a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showcert -h")

    assert_match "O=Let's Encrypt", shell_output("#{bin}/showcert brew.sh")

    assert_match version.to_s, shell_output("#{bin}/gencert -h")

    system bin/"gencert", "--ca", "Homebrew"
    assert_path_exists testpath/"Homebrew.key"
    assert_path_exists testpath/"Homebrew.pem"
  end
end
