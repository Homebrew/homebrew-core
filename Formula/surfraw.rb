class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://packages.debian.org/sid/surfraw"
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/surfraw-2.3.0.tar.gz"
  sha256 "ad0420583c8cdd84a31437e59536f8070f15ba4585598d82638b950e5c5c3625"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9f5fc8020b021799c68cd204d4612f487c44315c15967be78a037576b378920" => :mojave
    sha256 "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9" => :high_sierra
    sha256 "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9" => :sierra
    sha256 "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9" => :el_capitan
  end

  def install
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
