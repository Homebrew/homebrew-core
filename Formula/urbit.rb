class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit.git",
      :tag => "urbit-0.6.0",
      :revision => "7633b5cc9cf249d873f16f08c09a1ee10a4f24d2"

  bottle do
    cellar :any
    sha256 "1f63270c438e77f54190e37ef7c2ee65cb56f9a0f34c752921a57aa4ebca4029" => :high_sierra
    sha256 "663d154873ba029384388b447fb035de0106913e0dab6ca6954bec675ab8bd23" => :sierra
    sha256 "f87e0b247871c0a9ba4ebb2904e44480160ecaf49f5efc12821d76fa5755b6fe" => :el_capitan
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
