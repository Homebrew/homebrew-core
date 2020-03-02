class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.4",
      :revision => "e8416596fb7c47e343b49ea5ec12c2a095873c2f"
  revision 1

  bottle do
    sha256 "8e790fe588afb0958e3bb42031700c1038162b7ee0014d9e01295d43b8fa6a69" => :catalina
    sha256 "8fadd8b147391223943436af1be232d605c357229ab6fcf490774329a36301b2" => :mojave
    sha256 "ce88690545c072ceeb4653faaa1527041029daac7101aeb8de55d44e55e88a39" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
