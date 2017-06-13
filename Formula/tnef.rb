class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.15.tar.gz"
  sha256 "ca76ad6d95665549c46f98160f5e4a63903ccf912f5c667727db3304a2978486"

  bottle do
    cellar :any_skip_relocation
    sha256 "f856c31c92e0d6383e7e1197c41bab0df91be739346c17c406090ac2c28c9a71" => :sierra
    sha256 "5e8b797b08b1fbee3a34c0206fbe38cc3114ba9fbaae846fd30bb8872f5fae23" => :el_capitan
    sha256 "26bc1ff1001a620386db559011522ee4edc8b74cb66cc3455eabd4e57c6a0ae9" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
