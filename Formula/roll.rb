class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.4.0/roll-2.4.0.tar.gz"
  sha256 "1c927908bce0b83477edca60d1da983b9d39646b5ece7574d33d8063422e7d5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4c65a73fa2d093bd663b2c8b538c3895ec563c161ee22e889b0f22d2a4d5902" => :mojave
    sha256 "707bf8f9b18c5d70172a5a820b4f1e94e74f53b677075974f3669d869ae2c003" => :high_sierra
    sha256 "982db93f320c57367a5b1284ef8b0167207fc4374bfc081bed80faf292a84ebb" => :sierra
    sha256 "23af32d0a51b8cd87637b83c401987f8896a3d7b0640458dd4fe15b1be0e67ee" => :el_capitan
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
