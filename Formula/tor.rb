class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.7.10.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.7.10.tar.gz"
  sha256 "647e56dfa59ea36dab052027fcfc7663905c826c03509363c456900ecd435a5b"
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
    sha256 arm64_monterey: "b564e5c58a7fedca5c997e701ab0f7d9839481034a8929667774e64e751dd9ce"
    sha256 arm64_big_sur:  "d231f9cb2b18b2a1f29210633ca715e50990cb6708faa5750221517cc4a000de"
    sha256 monterey:       "082b0a24e96d26908556bc4d71745e31688926531ce02e853c30067ef7e2ee06"
    sha256 big_sur:        "1e6ab9233486ff22ee8f324b0e915ae12e5b8936c18d8c8370ee1eaf540682ff"
    sha256 catalina:       "31e463839244224b2bd42e56987223e8d6ccfa2380b60fd087a53d9f052b8ce8"
    sha256 x86_64_linux:   "c4d0856a01dfe4985ba42ac94cc15d3f534cf1aa2dbb5952c8d14ab1b9f466cd"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
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
    if OS.mac?
      pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    else
      pipe_output("script -q /dev/null -e -c \"#{bin}/tor-gencert --create-identity-key\"", "passwd\npasswd\n")
    end
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end
