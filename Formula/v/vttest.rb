class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20240708.tgz", using: :homebrew_curl
  sha256 "c195449eb2d2299ca3c0a24788a9aab569fe41c2e0e83128b5c29ba96e5abb1b"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ccdcaaabe61dece07d72f9b6077b0387c6f3a42ae1d678b6c5269e4aeb861271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69c97efb95a1b780b9ca1702a22084de2830c512db6df2f5e4b34bfe13c4fc8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "713a46c6a0df4a65d990814d46d956862776ccfc5be0931c08466206b8cdf5d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77819cca774ece7bb3374e5ad014b47ac6cd26ef614facc5faa82e10adb51942"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7ffde78f54131579ce5915951fa80fcb65deb3fb907caef736ffb1e23f23822"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b0a9c2ec0f68c7c2b0d8e9ba2770d0ca7b714da718f96c0a112cfb3f41bb98"
    sha256 cellar: :any_skip_relocation, monterey:       "94015c34c88bbfb880374ee0e8bd8b2c57ff95afe2c728cfc2a9c04443642dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e8aede521accf9eb5c66a9d6651d5c6934b37bbe022edec647ab2bcd210f0b"
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
