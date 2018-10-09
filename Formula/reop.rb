class Reop < Formula
  desc "Encrypted keypair management"
  homepage "https://web.archive.org/web/20170706070539/www.tedunangst.com/flak/post/reop"
  url "https://web.archive.org/web/20170706070539/www.tedunangst.com/flak/files/reop-2.1.0.tgz"
  mirror "https://bo.mirror.garr.it/OpenBSD/distfiles/reop-2.1.0.tgz"
  sha256 "e429c7ff47f130bd465eaa0c23a1783b476bc484d32793592b54a568b55e49af"
  revision 3

  bottle do
    cellar :any
    sha256 "bde75b5da1a958623875e6b05c1d208ea22b712549164a37c7e68f9ee2d5aadf" => :mojave
    sha256 "e83e45b44f322b38e9476623d7a2e595b593a8499e06c94dd1124a10d59c0d49" => :high_sierra
    sha256 "8c0d3dd8ebe6732ec4d7820da74e12d7dc6b57ab79548063b1619213dbe79c19" => :sierra
    sha256 "a0d7ad0c9059426b6400b9294d27a7672789da0cabe051faf11b46b1121684d0" => :el_capitan
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
