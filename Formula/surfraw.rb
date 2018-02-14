class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://surfraw.alioth.debian.org/"
  url "https://surfraw.alioth.debian.org/dist/surfraw-2.3.0.tar.gz"
  sha256 "ad0420583c8cdd84a31437e59536f8070f15ba4585598d82638b950e5c5c3625"

  bottle do
    cellar :any_skip_relocation
    sha256 "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9" => :high_sierra
    sha256 "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9" => :sierra
    sha256 "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9" => :el_capitan
  end

  head do
    url "https://anonscm.debian.org/git/surfraw/surfraw.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./prebuild" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-graphical-browser=open"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/surfraw -p duckduckgo homebrew")
    assert_equal "https://duckduckgo.com/lite/?q=homebrew", output.chomp
  end
end
