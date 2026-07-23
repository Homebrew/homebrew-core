class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.5.4/tcpreplay-4.5.4.tar.gz"
  sha256 "934e0a9d4905110336a213598fcbcb4c657cc5066ee4de5a6727bd847b35afe7"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f816114b3aad61929cd61a1e146433b6b6d6488494aa5f1386de18ea859a0bd3"
    sha256 cellar: :any, arm64_sequoia: "615e6a6063933773a97fa79238ca3dda79e678a56df5945f9bd99e4d52773498"
    sha256 cellar: :any, arm64_sonoma:  "4f29108586861786ce8749ce1f779e2b96e47475978b0904dea4ddf7bba9089e"
    sha256 cellar: :any, sonoma:        "ce1a456ccc96bff176fb14b95118ce74b2e169e15c262ae10aab198eee1f3b0c"
    sha256 cellar: :any, arm64_linux:   "2788d6f32706a07bf00afd9065f1d8c9d5489429c72fc72c55cbb53633d7307b"
    sha256 cellar: :any, x86_64_linux:  "0ca1f27f162cd1f05482c12d932cc8f285fc41ee916b86ed9316d39593eb2c46"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-libdnet=#{formula_opt_prefix("libdnet")}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{formula_opt_prefix("libpcap")}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
