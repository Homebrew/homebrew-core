class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://surfraw.alioth.debian.org/"
  url "https://surfraw.alioth.debian.org/dist/surfraw-2.3.0.tar.gz"
  sha256 "ad0420583c8cdd84a31437e59536f8070f15ba4585598d82638b950e5c5c3625"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ab44787a663bbe67dd02da510bac3dff3806c43807e18c1a2a4c535bc1ecedc2" => :high_sierra
    sha256 "9f4c4f3deaad0b2d5fad49978bea059e9bfc2eb0acabe959d719c82facac422e" => :sierra
    sha256 "df27f0dc82f9f2f4efa5fc33244d66063592d0c7afd3d2dd8db0466ec10492d0" => :el_capitan
    sha256 "cf0dd3b14c4e8034f0d0766fb09978eac0f19fa41730d72ed1422a67c0b0d0b3" => :yosemite
    sha256 "1291ba20882c2dc1fbb092782e943ab0b99ad3642fb73db207dadff1fc00c5fc" => :mavericks
    sha256 "30b885dc5908318868da2739f36834ce071bc7bff1a761fdc395afe82f75efa8" => :mountain_lion
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
