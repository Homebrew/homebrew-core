class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.11.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.11.tar.gz"
  sha256 "2e6c1720118c812acf0079fd47cf91b6bfaba5d766c321c4d3d2a28d6a11a8ed"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]
  compatibility_version 1

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fe85b84a97cf9c1326ba8a3d1cfe2eb1c947f2c5f7e5b04cc9d6cca24a6b00f5"
    sha256 arm64_sequoia: "9272162fd5d64adf3306e92a0345fd292ac6aaed84fa7e6ccc735a648783b562"
    sha256 arm64_sonoma:  "f0ebbecc5a92d80689fb6a7bd2d014ac34c9a5e1115314256f2971bc5395cc62"
    sha256 sonoma:        "3ee6e2954a935b3a52b9467e3046920ef0afc23ba3e5af4a307c88c40755578b"
    sha256 arm64_linux:   "8acedc5007938e8a2a90247570531bfeb4e81ebb6d7e5a805270f8f132a7b896"
    sha256 x86_64_linux:  "9f2c4698fa757eb29bd2141462809a0794e60c0c839ec0b709a0705d91868bb7"
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
      --with-openssl-dir=#{formula_opt_prefix("openssl@3")}
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
