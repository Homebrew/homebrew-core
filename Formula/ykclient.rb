class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://developers.yubico.com/yubico-c-client/"
  license "BSD-2-Clause"
  revision 1

  stable do
    url "https://developers.yubico.com/yubico-c-client/Releases/ykclient-2.15.tar.gz"
    sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

    # Use HTTPS and disable old v1 API tests; without this patch "make check" fails
    # to work against api.yubico.com
    patch do
      url "https://github.com/Yubico/yubico-c-client/commit/0d45452e7fbe47e77e78ff23b480c77fd9c06f2b.patch?full_index=1"
      sha256 "1e4e85d9d009488cd81a87f54be0f67a5a4cee03d34e1f0afadbc92f5194e93a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "00e116a04b11a1d3c6d15f608d5088de2a1ac864b154da2494d9c3e5f7fa328a"
    sha256 cellar: :any,                 arm64_big_sur:  "39c01c0420ae7a6f3af3a97f9e413b3137730f251d4784bb5ab7f878793c34c1"
    sha256 cellar: :any,                 monterey:       "985f62c5ed17437ef7670ff6b9bc8b1db77049015701f5ed6587bf51ebd1edbf"
    sha256 cellar: :any,                 big_sur:        "9763765c3a3eb3d2fac970755b9c0ed1c48c8d74d7dd767dd824c8b0b3cfffd7"
    sha256 cellar: :any,                 catalina:       "1a0d524e983bd1b22c012a00d60c4529b776640386e978fb3f6046b52e17eed7"
    sha256 cellar: :any,                 mojave:         "6e1365c8a6d412ae2a65c65b741ab666340bbb384b730989e2833fe96e0b8e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e55e5726173eadd3061b52f6eb3d731076dc3c2056a5b43e55b0db7c816744e"
  end

  head do
    url "https://github.com/Yubico/yubico-c-client.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # "This project is deprecated and is no longer being maintained. For more
  # information and guidance on how to implement Yubico OTP support in
  # applications, see
  # https://status.yubico.com/2021/04/15/one-api-yubico-com-one-http-get/."
  deprecate! date: "2021-05-24", because: :repo_archived

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "curl"

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ykclient --version").chomp
  end
end
