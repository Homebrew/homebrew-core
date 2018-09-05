class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "http://www.nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.2.tar.gz"
  sha256 "dc90a8b2fbb62689d1b59333413b56a370a0715c38bf0792f517ed6f9763f5df"
  revision 1

  bottle do
    cellar :any
    sha256 "d684736818642560692ea0a2efa0bb2d43f41bb128312f0161a5ad21fabd8ad4" => :mojave
    sha256 "9e5ef47ca5780f4e6e855cb787a6f7926e90f007b5f45bd600f35c3e9782d393" => :high_sierra
    sha256 "820c6cbfc33a7705efdc801657111376ae4380a0a068df08011c2a0c6c3f50ee" => :sierra
    sha256 "4aa5c719528b14df3b6aedb0db15e97767492703c2fb3de0a48927224e1f126d" => :el_capitan
  end

  depends_on "libssh"

  def install
    # https://github.com/nullsecuritynet/tools/issues/6
    inreplace "Makefile", "-lssh_threads", ""

    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
