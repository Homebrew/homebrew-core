class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20201225.tgz"
  sha256 "069db5efca2325280bc14ffe14ff7085e3ddfe6ae152499155daa28d94b90421"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d99c891ef72835d79954094937d025a7e78d62c7ac6daccb9f924e20cff191bd" => :big_sur
    sha256 "146b65073bd5cbed58ccaa43a2af7854a45a642fd81e27418b23e232a9d5126b" => :arm64_big_sur
    sha256 "67bea69b355e52582b491452592cf3e752ea8c229303b5aad91fbf79f8d943d5" => :catalina
    sha256 "77bdb11dde1c90472cf217f61c02e05520cfe39ad8635aaaa28a7e3bddc7e370" => :mojave
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
