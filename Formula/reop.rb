class Reop < Formula
  desc "Encrypted keypair management"
  homepage "https://flak.tedunangst.com/post/reop"
  url "https://flak.tedunangst.com/files/reop-2.1.1.tgz"
  mirror "https://bo.mirror.garr.it/OpenBSD/distfiles/reop-2.1.1.tgz"
  sha256 "fa8ae058c51efec5bde39fab15b4275e6394d9ab1dd2190ffdba3cf9983fdcac"

  bottle do
    cellar :any
    sha256 "ef7c8dc250f93b18a84fc4b22006f1b5c59b34bf5d3fd3caa07da03184a0cf61" => :mojave
    sha256 "e0f5cdb5c8b3af4919afa8b442eba703dec9ef9f5b7a25cbe56440e6c646d3b2" => :high_sierra
    sha256 "1fdb2fd33a36c6cc57971c3399e2536ee2548acfde8761f0536cee33b2f61354" => :sierra
  end

  depends_on "libsodium"

  def install
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
