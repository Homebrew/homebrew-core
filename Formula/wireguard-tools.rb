class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180910.tar.xz"
  sha256 "43481ac82d4889491e1ae761d4ef10688410975cc861db5d2ac1845ac62eae39"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "548c1e879c017b8780c231606f94ae76c69955d7eb1bf92c9246191006a49ace" => :mojave
    sha256 "687f37f50113b6e8354af4c15a35cfafa55f6b2f1e18f1c429d5fac0f2147562" => :high_sierra
    sha256 "832129f787df46c323b6e0042034081870933e507bc5a6c7ec8725f2eb123a73" => :sierra
    sha256 "fc4b3a7f7288908e7557a80ab883ed32d1afbc0ff1d12fc21b10e15b70a09d9c" => :el_capitan
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
