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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35b87b120597b9e19bc14586ef66fde370b95ab1f175c1cb355b8dd5d5a1a900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b87b120597b9e19bc14586ef66fde370b95ab1f175c1cb355b8dd5d5a1a900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35b87b120597b9e19bc14586ef66fde370b95ab1f175c1cb355b8dd5d5a1a900"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d24e9dda3720a583e5dc6d65ce64f8b0497a6c8eccf292c38e642b405868b5"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d24e9dda3720a583e5dc6d65ce64f8b0497a6c8eccf292c38e642b405868b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d24e9dda3720a583e5dc6d65ce64f8b0497a6c8eccf292c38e642b405868b5"
    sha256 cellar: :any_skip_relocation, catalina:       "f6d24e9dda3720a583e5dc6d65ce64f8b0497a6c8eccf292c38e642b405868b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd9e7adf1d19f3476bb1ac66ee70ef913837b2f719bf076a4cf4ae98ee14c8a7"
  end

  depends_on "python@3.11"

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
