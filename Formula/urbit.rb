class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit.git",
      :tag      => "urbit-0.6.0",
      :revision => "7633b5cc9cf249d873f16f08c09a1ee10a4f24d2"

  bottle do
    rebuild 1
    sha256 "d8b27d852fa3508ce51c34ec4a66f885449a2c4b0a2b8cbfe6b31ed580dcceaa" => :mojave
    sha256 "b13f985e22cb451d6bd2bf0060b0d106f706550100805388bc295d0553a4272e" => :high_sierra
    sha256 "b983f7e4aa657b96409603575589f3c411cf639c93586930b796ac278ad6e3ac" => :sierra
    sha256 "02b46f9c7977498538159ecfbcb394a7b5cf77a6a547676534c8fd04a6d0e987" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl"
  depends_on "re2c"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
