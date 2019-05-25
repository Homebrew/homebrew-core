class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "http://www.nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.3.tar.gz"
  sha256 "30d1d69c1cac92836e74b8f7d0dc9d839665b4994201306c72e9929bee32e2e0"

  bottle do
    cellar :any
    sha256 "d684736818642560692ea0a2efa0bb2d43f41bb128312f0161a5ad21fabd8ad4" => :mojave
    sha256 "9e5ef47ca5780f4e6e855cb787a6f7926e90f007b5f45bd600f35c3e9782d393" => :high_sierra
    sha256 "820c6cbfc33a7705efdc801657111376ae4380a0a068df08011c2a0c6c3f50ee" => :sierra
    sha256 "4aa5c719528b14df3b6aedb0db15e97767492703c2fb3de0a48927224e1f126d" => :el_capitan
  end

  depends_on "libssh"

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
