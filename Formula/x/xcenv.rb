class Xcenv < Formula
  desc "Xcode version manager"
  homepage "https://github.com/xcenv/xcenv"
  url "https://github.com/xcenv/xcenv/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bbb47394f9edbdabba886e5ca0155f0ef6aeae07b8a7564c652c8e260fac6d9f"
  license "MIT"
  head "https://github.com/xcenv/xcenv.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "5d7a035c89c0974f1361a611e476889cef15ba0c2c225f93bde9f58c418bd1f5"
    sha256 cellar: :any_skip_relocation, all: "65bfc4db841df3001acc419d3d784768a955462fe78faa85c7674132aeb78bb4"
  end

  depends_on :macos

  deny_network_access!

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
