class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/c1/8f/f99cd5ad86d07a13885a78a83edf95bb8b9ff254d3b8c25b4437b6c35b49/trzsz-1.1.7.tar.gz"
  sha256 "72c7dc2b28e417101ccf8bf59e4fb0d28f4d54cbeb5acd5d08c4d6968e2ca6af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2650699add83bc75e4b25b7c9568b2e4736c9ef5b1d026402abfe51425a4274d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2168398fe2284eb81b524b635bde3a7e4581119f47689dc55e6db47c677fc10b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a8129bdae773b873cd3ce92c0d576acd85203b754d4a9b1da632858fe9259e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "06c1bfe07747e515ec287c6e5adc4a4fbcf55a87044248d2eabac22a46d3c983"
    sha256 cellar: :any,                 arm64_linux:       "31cbe696edf198541b4e938335085abc5d27d7920fd8d66fb147990d449c0e54"
    sha256 cellar: :any,                 x86_64_linux:      "2e6aea49c7ed5198dd7c7a550f90b7ba2d1eeb460b513730853de16430d31eb5"
  end

  depends_on "python@3.14"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  pypi_packages extra_packages: "trzsz-iterm2"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/a9/eb/3b0eee58d952b693e7cfd693e172fade70d75aebf62e619fe9be12acf938/iterm2-2.22.tar.gz"
    sha256 "35f050bdbd1a459e70e3774ad7e922cf1ea36b650c9d7eb59ddd93e3dbb9f308"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/a7/e7/0553e21d25ca4d9f573135775348a372c3ec34a93a71d5f297c3bac38341/protobuf-7.36.0.tar.gz"
    sha256 "e8e09cb0d794c6687926fa558a8a6e72aa10edb997d5ca61da0765f12a3e00ea"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/41/c6/a8b16af3a7a2e0b85ceb1d270e4493edb464af7144c8f49a5ade2bf9f45a/trzsz_iterm2-1.1.7.tar.gz"
    sha256 "2d93969c57df4642a92e44bdf960b2b0c5fad07f4111b9045c33b920abccbc41"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/fb/4d/017a7455f9bba3649a09272877f576e80968adf8b592b3469c7f72d49247/trzsz_libs-1.1.7.tar.gz"
    sha256 "287e3005d8ae14f7b0bbda8808f3fd5e4ca401e5d86e7e5ac53b88acedcd9f60"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/70/26/41da498a42038f11019738f0454428c963638b8feea98744a14e341b07ee/trzsz_svr-1.1.7.tar.gz"
    sha256 "2261a2ae2324b050524465e306a30ddf6ede6a1aeb1a4eac6423414044fd7599"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/18/72/fba934cb3dff7a85d811820efffcd141ddd52b5a2a01637f64551373ff4d/websockets-17.1.tar.gz"
    sha256 "acfea4c20bf54384883ea33b1240fc1db4f52e190823a4e2b334bc3e8bfca96a"
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
