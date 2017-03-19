class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.kernel.org/debian/pool/main/w/whois/whois_5.2.15.tar.xz"
  sha256 "7a5a6b690bfc6360d92d9328adbe5c1f096a41f0d6548ce0df4aa664dcb37188"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd0248e4f6d4313750eafb776dd7685448b6f4c3436f0839dcc79040d15ba19a" => :sierra
    sha256 "f5bde04e75e69f72b3d7b5b2383ff562a81bdb66d549fbabbbf55ac281904ee0" => :el_capitan
    sha256 "0402bfeff02637945f2a00fbeb6401439730a23b26e6be0d9fc21d243f63520d" => :yosemite
  end

  def install
    # autodie was not shipped with the system perl 5.8
    inreplace "make_version_h.pl", "use autodie;", "" if MacOS.version < :snow_leopard

    system "make", "whois", "HAVE_ICONV=1", "whois_LDADD+=-liconv"
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
