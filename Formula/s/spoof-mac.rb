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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92de0b0b0e692ab4cce0c11186764c0f958d60bab3c3f0d00bfd0826d5322207"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0490f26b9569a49e4539b30d188cce6f4f341072baaff3acf7319b9197991ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cba43539b88bb2eab269c77811ef39ec51d15b429074f35aa1a9206e3fd9963d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebbde2128796667f8b7b558e421734a1ed54fa44f516edfdd9dd9c763d6420e2"
    sha256 cellar: :any_skip_relocation, ventura:        "de6a9198d8e6fb51b6eac74a402e9529531e7e6ffc4e6cc106b6305c8603a424"
    sha256 cellar: :any_skip_relocation, monterey:       "7078d35e9559593b7727c9786acc7e9da7cd93b3d7f99e1e392d08f56f683356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c5b8478bdda5fb00e10924a79d3544b26bd04271f553e8670255029c640538"
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
    system "#{bin}/spoof-mac", "list", "--wifi"
  end
end
