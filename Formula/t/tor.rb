class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.9.5.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.9.5.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.5.tar.gz"
  sha256 "c949c2f86b348e64891976f6b1e49c177655b23df97193049bf1b8cd3099e179"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7d792f62a46a6218dca7a4568e4f9a891d1fdbb201af2859920df3a5420b5f39"
    sha256 arm64_sequoia: "442352ca0dc22fc40bdb8beea1a3f1d8dc932603bf14cb16e51f8d5161166914"
    sha256 arm64_sonoma:  "7272ec29705c56be7d7cd76a60e39257d8349d0694eae3df2d88e05dfb685079"
    sha256 sonoma:        "4d41ecaec0d95286308b33d5c375f12722fd9184ac3386d006091f48a09748c8"
    sha256 arm64_linux:   "6c925c345ce39c546ba733810a1b40feb3df72b185424bc2ca67d422e3517253"
    sha256 x86_64_linux:  "8c926840c71b225e857264c374932818854ca61386066165b365a3ec58ecadff"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  service do
    run opt_bin/"tor"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tor.log"
    error_log_path var/"log/tor.log"
  end

  test do
    pipe_output("#{bin}/tor-gencert --create-identity-key --passphrase-fd 0")
    assert_path_exists testpath/"authority_certificate"
    assert_path_exists testpath/"authority_identity_key"
    assert_path_exists testpath/"authority_signing_key"
  end
end
