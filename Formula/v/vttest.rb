class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20231230.tgz", using: :homebrew_curl
  sha256 "4ae623c77b797e7f94946948d0b27e46ab4e01d843f6260800c57390aa04cbf5"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c8f269a12d55c6e7e938d98df8f49cbd2db40d774095bffa4875fbc911bc122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e48a3e6034099c2d8251fb2380f5076dc9c55e0b78d0a5df4d9eb3bf5f2919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2e3531ce14a02043c169757d9f817b45882861cc10757170d2eb717222f4491"
    sha256 cellar: :any_skip_relocation, sonoma:         "98d17f9ab649a6d48dba9c25768cbbc0387b812077ff3c9f9aeb9f3bcbd65909"
    sha256 cellar: :any_skip_relocation, ventura:        "823c177cf29b8253a65b98af596c9eeb0db596a2f4b2458b0419ae7dc21654fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b52917bf474c28cc291ec8a0c336c50dcd6cc09cb29905ae750e67cc8f7e777a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0dbef1013f83259ce7d2d133ee2e1310c57d46e22f6076159ee027442e9e27f"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
