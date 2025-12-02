class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.2.0.tar.gz"
  sha256 "c5114b8042716bb70691406931acb0e2796d83b41cbfb5c8068dce7a02f99a45"
  license "ISC"
  head "git://git.skarnet.org/s6.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92ca9064a5fa950d6f77bd56dd55024b381f4458d4df539d859f384a60e3b28c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88fb583281e696ad18a4dab7b34ec8794d1c58dfa48c40a4b6a020138f26b0d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105a08c0079ab7fb9fd049443a888ec673c2f3e4e241d4a7cd52065403881b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de13a9f0b0d00175ce1365152621f160759d3de1d8344f520d19ff29418d5c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecc8dab8a302e3f58a67b5e48269eb272018d9cc8d22ba6d2bfaebb5ade0835e"
    sha256 cellar: :any_skip_relocation, ventura:       "1ae26881433c5dfaa3b514e161423d44f8bf22431c75a39d54a0c6507ff4d9d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267d6e94207cb929ba43e44a4bd589e7628fde0cbf42d242069e1c5af2f82f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f710b9295a5a5101c380603ed1741a4df17e5af0f5b21b7ea953c6a46065d12f"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
