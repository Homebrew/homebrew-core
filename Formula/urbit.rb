class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.4",
      :revision => "e8416596fb7c47e343b49ea5ec12c2a095873c2f"

  bottle do
    rebuild 1
    sha256 "276c35fb585e1c359f46b96240795208dee6019b4e589777dfa4354970d879fe" => :mojave
    sha256 "ee4b4668c9d3e1e18ac3df46bf8ab1b87b12d2ada63f85af0f5013abb0c6416e" => :high_sierra
    sha256 "7fcc589b3b5deb3fac7e6be5398679555b30a3be897cb336cb8c005249fb3548" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
