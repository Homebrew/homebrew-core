class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  stable do
    url "https://nlnetlabs.nl/downloads/unbound/unbound-1.18.0.tar.gz"
    sha256 "3da95490a85cff6420f26fae0b84a49f5112df1bf1b7fc34f8724f02082cb712"

    # https://github.com/NLnetLabs/unbound/issues/928
    patch do
      url "https://github.com/NLnetLabs/unbound/commit/17a557dfd5eadb8f0b812d25cea28deccaa62de9.patch?full_index=1"
      sha256 "59710836ece231ff89c2cdf7257723f30e9f18527076b4a5bd7b6b3c0e494112"
    end
  end

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cd2cd768b043b13adc8e5017856c9c50e72275a13ee08374f73b8eaa068800e5"
    sha256 arm64_ventura:  "c2eda6654a2643a7615778c4e565d4bd892d4db6793744382ed7651d1d447d65"
    sha256 arm64_monterey: "2bdae3f32da84ff6a051e8b3bd8dc81fa6264fae100b1ee30da0e9d61b7c9462"
    sha256 arm64_big_sur:  "6010cd37fb6961c9266bd2fddefc4747b82914774be8de23a7be8e8931c7860d"
    sha256 sonoma:         "9927aa9c3a63353a14dde9190c151574598481e7b1450c9e06dd81b046588614"
    sha256 ventura:        "ae41104389bf249c8f26eb5db079a66485a9a3c0b9df1c7d16582c8b813adc00"
    sha256 monterey:       "eef12398b6ff2e7296a6d4f1ce9b8927b7b850d307ce6347f81558a2a523a378"
    sha256 big_sur:        "9826b2f8e37c87b1f43c5d2f8e0c9fe9cc3d3afa7f2626c24a82db439904c6c1"
    sha256 x86_64_linux:   "da10e82c76362d4434f46b14bd8b3d1ea782c2ad1f95cf2e4645f6ec0841118e"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if OS.mac? && MacOS.sdk_path_if_needed
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')

    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  service do
    run [opt_sbin/"unbound", "-d", "-c", etc/"unbound/unbound.conf"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
