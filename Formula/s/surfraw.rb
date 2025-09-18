class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://gitlab.com/surfraw/Surfraw"
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/surfraw-2.3.0.tar.gz"
  sha256 "ad0420583c8cdd84a31437e59536f8070f15ba4585598d82638b950e5c5c3625"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "41fcab9dbdb65112b701d420fee1d2411b1f8af7115bb7d5412eb822f27e30ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8d04a21e14ecb8b591159c55dbc4a0af5ea0eadaa5dcb581c6c6c4a74d0b0e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8369f05a6c7e4b5e99a6e41d94143ad66c598cdfd40aef9402302bb4a6e51c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafd188589a5aaa870da8aa6e44a6e970dfed59dac958b3abc426414f670061d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafd188589a5aaa870da8aa6e44a6e970dfed59dac958b3abc426414f670061d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "004471f242a93bd3cfeee2fe7ab6e06b4fecc83e0df9f2bc28a1048fea431eaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "909a14dec923c593a50ec318616b2f94348365c4dd07f4c8d77bf7a213d52ca8"
    sha256 cellar: :any_skip_relocation, ventura:        "4cab376ccfaadef6faed89f0f7fcb8cb2a160dfe1219c8138a2debe3dedd0ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "4cab376ccfaadef6faed89f0f7fcb8cb2a160dfe1219c8138a2debe3dedd0ae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b24dbd4f8a768ca2192578897e2285490687a9e5e6d5b92558e3f6d83e92919d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a199f462c1b1276aa99ec530c64775edc15565eccaecca23c99bbb9474db0024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1b358e902cb7ca1a8477e5fe4953ed7b0dcea29717e9f14328ff6fe60e922a"
  end

  head do
    url "https://gitlab.com/surfraw/Surfraw.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-graphical-browser=open",
                          *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/surfraw -p duckduckgo homebrew")
    assert_equal "https://duckduckgo.com/lite/?q=homebrew", output.chomp
  end
end
