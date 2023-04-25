class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/0c/e5/00c95527d18445cbd3b3b2c5c28a383c94c9ac5291e886796004727b25aa/trzsz-1.1.2.tar.gz"
  sha256 "dfc9606fb7ae76490c8559ec297b307a788688351ab57108f6a733105b206052"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfdc64f012d48589793eb056c5954466c3f6e5f985a7f7bff2457635aa662349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68ef45a8aaff53589d071386578eaf07d50e9987b6f8409441f9233ac1463d7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a81db10a9ddd489f4442fd5149ba633e94b8345260b09d3e71fd7f943203404"
    sha256 cellar: :any_skip_relocation, ventura:        "97e7c7fade42b12f7556d135f2d2e3a20bed81e3b968d819a4df6b16b9fc9426"
    sha256 cellar: :any_skip_relocation, monterey:       "265059568e4003ec1e189751fe3ba196066b4c048d024d96b2c03fc44a09bbae"
    sha256 cellar: :any_skip_relocation, big_sur:        "28ed2c288e251407f7850123c623d874815d8607c7c84fd3bb8ca66a558bff2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7183da3e45ab5a3bcd18085b5286493adb00260829ebaddec0c791545250527e"
  end

  depends_on "protobuf"
  depends_on "python@3.11"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/ea/f8/2d26c13f511116d8dea8f4bb4610144e4a85afee1b7ddfc96f4abfbead10/trzsz-iterm2-1.1.2.tar.gz"
    sha256 "5ba2600c9beff4a3e45d79341c944482c163a93ae418630884b212e5a09bb3bb"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/21/6b/fb791246cc8968dde9f35fa2f5cd404dc17faf698991150eb1cd7a858f18/trzsz-libs-1.1.2.tar.gz"
    sha256 "3ae44d4cb8ce20448712ca9269eb213c59b62b203531e2fb886f14caaba338fb"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/a2/ef/2740a48fe69e2086ad6119e0cee51ac56f217faec3de54ca4aa03bb1efff/trzsz-svr-1.1.2.tar.gz"
    sha256 "299440a5b3284a86ae9256b8d0cf9ac3e5ad9b23068319794c62963871a37e53"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
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
