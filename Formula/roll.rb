class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.2.0/roll-2.2.0.tar.gz"
  sha256 "995e7e179025ee69c93e33e2dd707384391ac2bfb69e97368bdc873a5b93f6b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7de0af2d2df29ada5a2fbf068ee19eada32a4e9c7218045e100e929739804d2a" => :high_sierra
    sha256 "3e1c5e29280738312b3f94a825128ca23058a12013c59ff3e682fd699dd65a48" => :sierra
    sha256 "b2a40f39757f7327df27f9de7fd751e7258117cf581ec797665739cbd9a96801" => :el_capitan
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
