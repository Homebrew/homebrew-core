class SpoofMac < Formula
  include Language::Python::Virtualenv

  desc "Spoof your MAC address in macOS"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://files.pythonhosted.org/packages/9c/59/cc52a4c5d97b01fac7ff048353f8dc96f217eadc79022f78455e85144028/SpoofMAC-2.1.1.tar.gz"
  sha256 "48426efe033a148534e1d4dc224c4f1b1d22299c286df963c0b56ade4c7dc297"
  license "MIT"
  revision 5
  head "https://github.com/feross/SpoofMAC.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "896dfbb0ecd231f39803a2613f6f8e957ba51678726d05bd18ffaf6bc37889cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b5b283ac01d458293d93788dea4acde6975b4e6cd88a6d18deb9692b2c1024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6cc086a652071944e7bd0c49a2a02b9d72d825c3c88f5481b4e2c63a48b0658"
    sha256 cellar: :any_skip_relocation, sonoma:         "3caff99ef4a85c18d5826a9323105a2b1cf3ae70ac53a874353382a713cd7c81"
    sha256 cellar: :any_skip_relocation, ventura:        "649cec73533c1ee598190d0693fc85fcc2d2fdb1452038531da1d5a6f4299737"
    sha256 cellar: :any_skip_relocation, monterey:       "a1bbf8d8fc4cfa12a86f3154c114d46f6909e153a550c1893b74c8a261a03dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f5dbc8a9ae8952a603b6252c4eaa2f12819da4cd96a0033958bd71811920d6"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "net-tools"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Although spoof-mac can run without root, you must be root to change the MAC.

      The launchdaemon is set to randomize en0.
      You can find the interfaces available by running:
          "spoof-mac list"

      If you wish to change interface randomized at startup change the plist line:
          <string>en0</string>
      to e.g.:
          <string>en1</string>
    EOS
  end

  service do
    run [opt_bin/"spoof-mac", "randomize", "en0"]
    require_root true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"spoof-mac", "list", "--wifi"
  end
end
