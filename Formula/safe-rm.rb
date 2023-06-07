class SafeRm < Formula
  desc "Wraps rm to prevent dangerous deletion of files"
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/1.1.0/+download/safe-rm-1.1.0.tar.gz"
  sha256 "a1c916894c5b70e02a6ec6c33abbb2c3b3827464cffd4baffd47ffb69a56a1e0"
  license "GPL-3.0-or-later"
  head "https://git.launchpad.net/safe-rm", using: :git, branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0934761b2d4741420d698f2ef02e25fd76040a2500d749a1c6d80a7f9e0a09cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a5b094b23fbfca81cae6a07b707f3ca0dca9ddaf742568e425323d37a69995b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ff1f149a5e8968fd7ac345231c38250aa3f980ed26f37c375b5f700d2206464"
    sha256 cellar: :any_skip_relocation, ventura:        "f74882c3fa9424387c06d431f2b05eaa69f160955a7bffe441957fbd30017b10"
    sha256 cellar: :any_skip_relocation, monterey:       "cb53a3912e9e93ae9286a694466e97f3e38834034c2fafe06866a1a5b04d0532"
    sha256 cellar: :any_skip_relocation, big_sur:        "e13cda860afbd1897715240f11f06dbd0c2ca6c6834a5ff1a505b31c66ca63fa"
    sha256 cellar: :any_skip_relocation, catalina:       "e9f3f483c1cd132ac44afd0890d93296507f8438d2c7921ff73e4cb7d4cc54c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91dab1f67e634f6c93fe3461d2839d46c73b6e7fcf7c6f4091dc09b863a3f65"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    foo = testpath/"foo"
    bar = testpath/"bar"
    (testpath/".config").mkdir
    (testpath/".config/safe-rm").write bar
    touch foo
    touch bar
    system bin/"safe-rm", foo
    refute_predicate foo, :exist?
    if OS.linux?
      shell_output("#{bin}/safe-rm #{bar} 2>&1", 1)
    else
      shell_output("#{bin}/safe-rm #{bar} 2>&1", 64)
    end

    assert_predicate bar, :exist?
  end
end
