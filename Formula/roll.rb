class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.1.1/roll-2.1.1.tar.gz"
  sha256 "5d499c690d30cbe93dc571eb8e3f11d1505ce4595c8151646777548ef89a7997"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf42fe63830aa9b363962c6cfbdeb79065cad24b70b32710dfe0eaefe47a1dfc" => :sierra
    sha256 "67d9f2bfdfa266bcc01a76b494eb9d897f0a9385f9ae4d9dd12783ec675b8e99" => :el_capitan
    sha256 "018dc40d3339a486b49401fa7ba43fae3c27879dbec29c3fbea73cc64c51f647" => :yosemite
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
