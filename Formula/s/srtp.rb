class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d123dcff5c56d4f1a9006f2b311ea99a85016cbf3bb24b1007885d422237db85"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/cisco/libsrtp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57991308e7a77e9101f56b5746b72dc84d7ec71cccb0952255e150bb61fa8b31"
    sha256 cellar: :any,                 arm64_sequoia: "456aa17cfcc530e2e116ea4dc8dc8bac7d1f57e82e9354da9c5afdf73efb719a"
    sha256 cellar: :any,                 arm64_sonoma:  "fe511a421b2601d56208bca5b723dcf0cedabac7820b6dbc29b2e9a9975027be"
    sha256 cellar: :any,                 sonoma:        "1f4d6d9dd142b054f6ce5951553620d5638bcdad5b476049a8d8aef66699f3e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a50543ee3639a000b4e79006e72d66b7023905bb96a7b2699fc839cf16fd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efdbe2656736401da2b1b83008f1b61be3831f33c675d77f1b3446888a01813"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--enable-openssl", *std_configure_args
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
