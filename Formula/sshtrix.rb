class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "https://nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.3.tar.gz"
  sha256 "30d1d69c1cac92836e74b8f7d0dc9d839665b4994201306c72e9929bee32e2e0"

  bottle do
    cellar :any
    sha256 "e115c5a6f3378af5a0ab4297673bb7b659dd20054ab91d818b083ce13951e7da" => :catalina
    sha256 "a54f2c867dd6539824cc69888975d3cd2041b4b922183262d29fcdf655391cfa" => :mojave
    sha256 "dd567f106a7fe8a7a6f9e2474b284109e1dbcb14ed847163d1f65f4d69467f93" => :high_sierra
    sha256 "dafb3bc8c14e729cbbfbf8dc6a9ce789e01732a644aa84b243af24f2bd92ce19" => :sierra
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
