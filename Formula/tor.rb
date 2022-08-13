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
    sha256 arm64_monterey: "56e43aef0dbce13510fdc3bd3bf9a6b6a696ef6542f989dccad2715c1817a013"
    sha256 arm64_big_sur:  "5b0525c180c8f32c48e82f3622f1042d57c58b287963a5a427d1cc04a61624a8"
    sha256 monterey:       "995e3ba8da26341f87cdbb293399385c067efc0c6f69b99698166e022021cc82"
    sha256 big_sur:        "96ad5969cec746a4f79a8505e6ee89e6a266ffc0da72da6384efb8ea53de3c09"
    sha256 catalina:       "da25d5ea0e28cb3da05b89421c7822ccf6662b0448886f1b85470f0cdb786d13"
    sha256 x86_64_linux:   "2b16a493a685776f1fa1ee9bc841053e0306502d1af9c43a038a01b9b727292b"
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
