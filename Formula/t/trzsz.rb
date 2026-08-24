class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/24/78/71a4e96076f3df96a072d248b3c8de578972814ea745413cdff29040188b/trzsz-1.1.6.tar.gz"
  sha256 "d7a6cfc3c46951c2db873d848a54eec03ec9be9a36a8cfb77eed3ba2c8905c88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "346a4028116b85d1ab52abaa49d62c58f0a24208ea9dd7f08a64b386c1c10cb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81387485cf672271ec42363eee7029145a416eac8eb9fb1191d988046e882a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be9feb305016773b3144a60c837bd6e307ae9fb2a29b5010d772959b9e4d0213"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c8d72e27014c54c0b7eaa2351d0923ace0ab38ca4da69cbc5ae2685dcf795ce"
    sha256 cellar: :any,                 arm64_linux:   "3943954a4ada50bce1582358a7dd67084f4d74182f33a12782b3f47c1c5d2d05"
    sha256 cellar: :any,                 x86_64_linux:  "40c974e65220ef1c733a125b4d7a36daebaf4c573e7d21c5d7a253f935641f3e"
  end

  depends_on "python@3.14"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  pypi_packages extra_packages: "trzsz-iterm2"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/fb/258e7e3bfcacf9cdfc378ae4ee2aca743dbccd6a12ffceee12957f67dff3/iterm2-2.20.tar.gz"
    sha256 "168d3807cd58b3e678476852be2bb4a5cd89f008d95e37d2777d9810731cff08"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/a7/e7/0553e21d25ca4d9f573135775348a372c3ec34a93a71d5f297c3bac38341/protobuf-7.36.0.tar.gz"
    sha256 "e8e09cb0d794c6687926fa558a8a6e72aa10edb997d5ca61da0765f12a3e00ea"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/7d/bc/bad2010906445e8a042af58809587927f74f40656121f26d0ccc63ac1a6c/trzsz_iterm2-1.1.6.tar.gz"
    sha256 "768008e87b1e3deac68c834deccc752378c5e6d07734bd2b650f90b52b202fe6"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/7c/72/579ec2b8b0ac79f7775f8ab44b71a1247ff68e30fe0ea0d556d4df2ad0b4/trzsz_libs-1.1.6.tar.gz"
    sha256 "aad1a565c2165689adbf9221ed3948b801c120fa86ee8b75e722bbde721d40c3"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/52/fd/4a1a908202a96460ce1667b667cc45b9aeac76d951a658dceaaebbcf0410/trzsz_svr-1.1.6.tar.gz"
    sha256 "e0347f4a9894693fd9fbff0e6faf50eebc0040fa87ceb949a5f06cf1112af638"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f7/96/e01084f83a64bcb3a27994bd0cb0db68ff29d9c6707fae37ec19b18ba990/websockets-17.0.1.tar.gz"
    sha256 "5baa9bc0dfbae8c507e51c8cf1b6d4628086f7a87bbd3a9952bd5f035451f1cc"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
