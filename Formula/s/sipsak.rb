class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.8.1/sipsak-0.9.8.1.tar.gz"
  sha256 "c6faa022cd8c002165875d4aac83b7a2b59194f0491802924117fc6ac980c778"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "37a5656c10f93d897736172dcbd077d323c3c6924f28cf88c8cfd70adbe4443f"
    sha256 cellar: :any,                 arm64_sequoia:  "fc163d012b766abeb36447d0077a3711ba87868aafaee12c1ddd4a68e8e650af"
    sha256 cellar: :any,                 arm64_sonoma:   "267cd68ed07f710be35f79c815be4d80af199a7409d97f3dab329cc23ce124f9"
    sha256 cellar: :any,                 arm64_ventura:  "fdf8e854dbe1034dbf7a71760e4246bc6550a322954888fd0673284eedfcbe55"
    sha256 cellar: :any,                 arm64_monterey: "e125f43909ca4f4a28524262a30f0e9428db17ba255c9ebe99fae92d031ee1f2"
    sha256 cellar: :any,                 arm64_big_sur:  "3ea5541c6c9e917890818c783eb555a6952ddb839ee431d4ab2fda5529e9a9d6"
    sha256 cellar: :any,                 sonoma:         "1e0913edfc8c9b359162ba1a77a93d657aca595f7f5f3afa5f55042028719570"
    sha256 cellar: :any,                 ventura:        "617c93ad77b71f6c68eb81eb2a6c8e6c084ece627be89a18b37fcf2fbad66aac"
    sha256 cellar: :any,                 monterey:       "4346791be5ee36c5436de257f75ccf2ef31ac8f99883566c8679bf8e4d13d361"
    sha256 cellar: :any,                 big_sur:        "f2f76d68fa6c9c88abcd0132201a395a54f2ad31c73ee49dcbfcb69dbfb20ede"
    sha256 cellar: :any,                 catalina:       "3a756aed37b8bd2a3ff62c517847c82732fd2f9a7b5bf85dfac83704d18d6539"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5613441ee9f747ab3c144eae245696f163b027884dd3fec4d7cf00b00a1168fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f5a4948c437e0d89e33ff28f04842ef4c954fcfd9ed432da36620c20b6ca24"
  end

  depends_on "openssl@3"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"sipsak", "-V"
  end
end
