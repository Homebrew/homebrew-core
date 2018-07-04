class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.2.0/roll-2.2.0.tar.gz"
  sha256 "995e7e179025ee69c93e33e2dd707384391ac2bfb69e97368bdc873a5b93f6b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b7feb2bbfc8c8b9fe26f5f0403353da6edc3d61d0e885b6f70c69a59a0b8c2c" => :high_sierra
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
