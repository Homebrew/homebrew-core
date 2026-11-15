class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "https://distfiles.alpinelinux.org/distfiles/edge/socat-1.8.1.3.tar.gz"
  mirror "http://www.dest-unreach.org/socat/download/socat-1.8.1.3.tar.gz"
  sha256 "06602ffd591e98c75b3dc1d66f0f19136cc666b0b2d95caad987d6ab2cb28097"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8216d9bb5ee04d0c8c8099711a81846dbd5b90e8b012ba9be3205a5e4cd3be6d"
    sha256 cellar: :any, arm64_tahoe:       "f59f7e2df3f1428f970cd4d7c260f316ff1378895319a6de915836d27eaf7ead"
    sha256 cellar: :any, arm64_sequoia:     "31d9e7870de62e53e7735298a2f1757581053ddc78fddab97eec0a53097b999e"
    sha256 cellar: :any, arm64_linux:       "fdb97fc1cb97cb27468ef27e9174aaa9a773200944917d1e73639256194014ba"
    sha256 cellar: :any, x86_64_linux:      "f65c3124803b8f92bc474a82009327ed5420794cc82d0bccce827d065f94b909"
  end

  depends_on "openssl@4"

  # Apply Fedora patch to support OpenSSL 4.0. Same change is used by Debian
  # (10-Use-OpenSSL-ASN1_STRING-accessor-functions-instead-o.patch)
  patch do
    url "https://src.fedoraproject.org/rpms/socat/raw/c0b6576097257ad24cd6f72948bada8bca9a588c/f/socat-1.8.1.0-openssl4.patch"
    sha256 "66258fb1b1f65236ad8da8cbfb689485356423e7f280dc8e524dc012c11a5687"
    type :unofficial
  end

  # Test connects to a remote host
  allow_network_access! :test

  def install
    # NOTE: readline must be disabled as the license is incompatible with GPL-2.0-only,
    # https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility
    system "./configure", "--disable-readline", *std_configure_args
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
