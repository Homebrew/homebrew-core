class Reop < Formula
  desc "Encrypted keypair management"
  homepage "https://flak.tedunangst.com/post/reop"
  url "https://flak.tedunangst.com/files/reop-2.1.1.tgz"
  mirror "https://bo.mirror.garr.it/OpenBSD/distfiles/reop-2.1.1.tgz"
  sha256 "fa8ae058c51efec5bde39fab15b4275e6394d9ab1dd2190ffdba3cf9983fdcac"

  livecheck do
    skip "No longer developed"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8db72af3ee635c310ecc3fac68ef41eabd0808442c295da16fc380ef9c78593d"
    sha256 cellar: :any,                 arm64_big_sur:  "2f19ce5ab996a6d2cf7e5152160f0f0298e3c19eed633a9c52c0d548b2be0017"
    sha256 cellar: :any,                 monterey:       "68ca1188f2246247c5025502802889c5483bdcd13ae49662ef8e231874dcd4d8"
    sha256 cellar: :any,                 big_sur:        "125c56793715854faa4c1785f48e119a364ea3fb3239ea7edc4d885b6071099f"
    sha256 cellar: :any,                 catalina:       "9a871be9b2fa42aa2d9e5035712733c4b764c4eb7497958389018f0451a16cd6"
    sha256 cellar: :any,                 mojave:         "ef7c8dc250f93b18a84fc4b22006f1b5c59b34bf5d3fd3caa07da03184a0cf61"
    sha256 cellar: :any,                 high_sierra:    "e0f5cdb5c8b3af4919afa8b442eba703dec9ef9f5b7a25cbe56440e6c646d3b2"
    sha256 cellar: :any,                 sierra:         "1fdb2fd33a36c6cc57971c3399e2536ee2548acfde8761f0536cee33b2f61354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d80f151eacf4cc18df604fb3bf3daf0e786e07b6e82860399dc20b8d30b6363"
  end

  depends_on "libsodium"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "GNUmakefile", "${LDFLAGS} ${OBJS}", "${OBJS} ${LDFLAGS}"

    system "make", "-f", "GNUmakefile"
    bin.install "reop"
    man1.install "reop.1"
  end

  test do
    (testpath/"pubkey").write <<~EOS
      -----BEGIN REOP PUBLIC KEY-----
      ident:root
      RWRDUxZNDeX4wcynGeCr9Bro6Ic7s1iqi1XHYacEaHoy+7jOP+ZE0yxR+2sfaph2MW15e8eUZvvI
      +lxZaqFZR6Kc4uVJnvirIK97IQ==
      -----END REOP PUBLIC KEY-----
    EOS

    (testpath/"msg").write <<~EOS
      testing one two three four
    EOS

    (testpath/"sig").write <<~EOS
      -----BEGIN REOP SIGNATURE-----
      ident:root
      RWQWTQ3l+MHMpx8RO/+BX/xxHn0PiSneiJ1Au2GurAmx4L942nZFBRDOVw2xLzvp/RggTVTZ46k+
      GLVjoS6fSuLneCfaoRlYHgk=
      -----END REOP SIGNATURE-----
    EOS

    system "#{bin}/reop", "-V", "-x", "sig", "-p", "pubkey", "-m", "msg"
  end
end
