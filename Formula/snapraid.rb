class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.6/snapraid-11.6.tar.gz"
  sha256 "f030a3830449a78d10af41320da0be21c60f88dc8d328ebd056e0eb7596161cf"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a0444bc1096ac8efbe5576ed7a36b42791fc34b54c2b7a8c4fa20b1ae45a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "575e6b4a43acb5c4cceef40f4edc5ab0563f40956d9bfbf943880deb5a7e3f48"
    sha256 cellar: :any_skip_relocation, monterey:       "28de15571b2e0d89ff0ad943b94f5bd5e001c1876d3e3b42273559dcc290cc45"
    sha256 cellar: :any_skip_relocation, big_sur:        "32a82709e61efa091356ec5fe1df021dfc28ebcc3fa5f532b295d01ad37c0310"
    sha256 cellar: :any_skip_relocation, catalina:       "8291c456a415a7ebfed247b29ee844d5e773625a91ba3a0429c801bf617987ed"
    sha256 cellar: :any_skip_relocation, mojave:         "9824c33527ff4e8079ad8e7c1962cfa6aa6ab168714f364d203162ecd7178031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb552abd4ed89538c9751ce457e2c63afb2dc0f5a1f94e0f2f47a95fa03a699"
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
