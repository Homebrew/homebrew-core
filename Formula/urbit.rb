class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.2",
      :revision => "54ec1258c099456317d4c51baca7eae7b1f545c2"

  bottle do
    sha256 "1af6e7d33dd74b3529a593586cfbe2a78bb6b011192f811b9224a44813b16427" => :mojave
    sha256 "23252d21fa1efa4673039811b1057a26349bb063465f0c260f431fdd1c64d255" => :high_sierra
    sha256 "57e4e75ccda16e337922530d6d259ba13410dfda38c1cf6f1ba4a2553dcf1a91" => :sierra
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
