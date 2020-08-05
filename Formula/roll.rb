class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.5.0/roll-2.5.0.tar.gz"
  sha256 "a06b9782225442c71347eaf745e47684a9227d55575e865f503266c06454586c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cda95b1da0131870732c0baf08750b50d492c42918ae14adaf7c1b4553a8419" => :catalina
    sha256 "c1c2251d5ac3b6a03065877f6c211f326909c7710f85441adf0d9987815b6c35" => :mojave
    sha256 "0fe1da205f9d37a29489ac8b437cefcd915041c47ddf95cae577369b46d8d7ea" => :high_sierra
    sha256 "f9c7a833dad6d95fe4ee83fccf0890f49dee962e9965a624cf5d483d86c72eab" => :sierra
  end

  head do
    url "https://github.com/matteocorti/roll.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./regen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/roll", "1d6"
  end
end
