class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://packages.debian.org/sid/surfraw"
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/surfraw-2.3.0.tar.gz"
  sha256 "ad0420583c8cdd84a31437e59536f8070f15ba4585598d82638b950e5c5c3625"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31d8b711776cd751f846106b974bd1aa944f614880f8038ba04b391120abe9c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65d1418f750b53be50f7d67e98791242056d4d7b5e21ba177899435fd9ac9d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "64fbd46e38561804f22a7bcd408fcbef55e312d2e7dde999088ae0ec78fb2906"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9e126e0e78269271cee0952d6576fb99c443f49449dc9196a53ee2eb65d7ea6"
    sha256 cellar: :any_skip_relocation, catalina:       "2a2267217bfdd25ea00b3a08f76c44518e33dac0192a8590e4b3bfa3b5d90073"
    sha256 cellar: :any_skip_relocation, mojave:         "c9f5fc8020b021799c68cd204d4612f487c44315c15967be78a037576b378920"
    sha256 cellar: :any_skip_relocation, high_sierra:    "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9"
    sha256 cellar: :any_skip_relocation, sierra:         "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9"
    sha256 cellar: :any_skip_relocation, el_capitan:     "69920395cbde5fdc2492aa27fc765d4dafe910e26d9d3a05777888425310a0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3928b063fffaf888f0c34a9ad0a4b943fa5c120bad110a1e4b5acc465965acf7"
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
