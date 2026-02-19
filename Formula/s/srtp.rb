class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "54facb1727a557c2a76b91194dcb2d0a453aaf8e2d0cbbf1e3c2848c323e28ad"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57899ec6d17890c82b81cdf7a80eee3a621a23e2e513d7c64fd972ae1301a311"
    sha256 cellar: :any,                 arm64_sequoia: "bfae1fd49d88223c76e1181f78b81bbe5f4cdfb02a4aec7fbeaf071e49725796"
    sha256 cellar: :any,                 arm64_sonoma:  "473e73636853af42e2173d6fe231380473d0bf5e7ff804ba53a2fc4a7b9b20f7"
    sha256 cellar: :any,                 arm64_ventura: "ffda680f84d2f5cb9cf8ea9d078b8386cf2f0cf223d2dfe5147bb739f8631c9f"
    sha256 cellar: :any,                 sonoma:        "7ac6524572afcc2962a2a22562f8253d0ef1f1bc80a78488c9a4a8fe5bdc7f3d"
    sha256 cellar: :any,                 ventura:       "57406d7cd6cada27a6c8717c32550234e716f9ae7989e28959f53204dc5a20a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb20fac89e4f213d8802f02a061735b5a55ba134d9e2c3bb4b581044c45ef51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dcfb6ace5a4cec086e56117194b86fe25292173d200abe1b6530b5cb7a9fd6d"
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
