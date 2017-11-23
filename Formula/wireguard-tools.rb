class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171122.tar.xz"
  sha256 "c52f0694f4e11129a80b60a0d2fe75729f1ad39e3fe4e3ee569629ff21e3ed89"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "5e0bea84e5354fe6a427a0edf662b7990adf66844b1bb4171c92e69e0c2e804b" => :high_sierra
    sha256 "1a5375aa0ca43c61a2a5ce541cafc7078c4b3c63def772f7bbdd3b42e380ed70" => :sierra
    sha256 "a1f136c515a08a2aebe90170875f4b0b78d831d7878fca9eb3bee8aeb12bb10b" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
