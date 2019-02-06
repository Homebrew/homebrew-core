class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.2",
      :revision => "54ec1258c099456317d4c51baca7eae7b1f545c2"

  bottle do
    sha256 "4ff75863ac7fe81c8fb01f62dce55c0932e2b2dd3ca4cc6151dc24e2e66d81a3" => :mojave
    sha256 "d8d1f0f33e5c827577dee17db652218962608647732820038e486dd65711444a" => :high_sierra
    sha256 "d6a807213bfe59f811428538fb27aa54657f956756dc190a81182ed306e6ab0f" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
