class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.1/snapraid-12.1.tar.gz"
  sha256 "49337d9bafa96c2beac0125463bd22622be2fc00f3b4dee7e4b0e864d2a49661"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78708e3a4c2f93c56e0af8441aa35282d20b258f7dfc2fd5ba6a3f78ff12cf24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16d757885ce58f495b0ab7c210c32385a998d5731e42ed32267df2365c564a88"
    sha256 cellar: :any_skip_relocation, monterey:       "912787b43bdf380ca5689fe5df0e751cd22721c8e09bbad5bf036037fdd896e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa18547de5904d3f9a109e340b98ce6290e3ebbb9324178697838205e7f340e4"
    sha256 cellar: :any_skip_relocation, catalina:       "282d78894d7e897e7d9a1d1c348ff3e6113db1a75e4cba21f05d9764d379cc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad355309464e57e016e38ac9d93eeff4d18582c32ab90f6e097ec93dab8f162c"
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
