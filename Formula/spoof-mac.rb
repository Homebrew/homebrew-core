class SpoofMac < Formula
  include Language::Python::Virtualenv

  desc "Spoof your MAC address in macOS"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://files.pythonhosted.org/packages/9c/59/cc52a4c5d97b01fac7ff048353f8dc96f217eadc79022f78455e85144028/SpoofMAC-2.1.1.tar.gz"
  sha256 "48426efe033a148534e1d4dc224c4f1b1d22299c286df963c0b56ade4c7dc297"
  license "MIT"
  revision 4
  head "https://github.com/feross/SpoofMAC.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72260ee010624f7801143abcb6a9a594ad76fc589b2e3179a1e7d2a8935c96e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c72260ee010624f7801143abcb6a9a594ad76fc589b2e3179a1e7d2a8935c96e"
    sha256 cellar: :any_skip_relocation, monterey:       "5e803ebae572b3af8eac3e6156c0e43b4e9ef3ce684f71b6fe8e4bcfdf4af362"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e803ebae572b3af8eac3e6156c0e43b4e9ef3ce684f71b6fe8e4bcfdf4af362"
    sha256 cellar: :any_skip_relocation, catalina:       "5e803ebae572b3af8eac3e6156c0e43b4e9ef3ce684f71b6fe8e4bcfdf4af362"
    sha256 cellar: :any_skip_relocation, mojave:         "5e803ebae572b3af8eac3e6156c0e43b4e9ef3ce684f71b6fe8e4bcfdf4af362"
  end

  depends_on "python@3.10"

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

  plist_options startup: true
  service do
    run [opt_bin/"spoof-mac", "randomize", "en0"]
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system "#{bin}/spoof-mac", "list", "--wifi"
  end
end
