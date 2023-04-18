class Tivodecode < Formula
  desc "Convert .tivo to .mpeg"
  homepage "https://tivodecode.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tivodecode/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz"
  sha256 "788839cc4ad66f5b20792e166514411705e8564f9f050584c54c3f1f452e9cdf"

  livecheck do
    url :stable
    regex(%r{url=.*?/tivodecode[._-]v?(\d+(?:\.\d+)+(?:pre\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edea82441461a1fb59d0b4ffff0c70063e2dd064bbcbaf7dd2f35a9fbc464602"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2289a446ab7ec226d1b6b3ddb042336d0a223009268984fa5d949394842e2e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5171d7774e6eed485e7b3d57e3dd2b9bc0e935f97dd7890109ccdb3c4975ab62"
    sha256 cellar: :any_skip_relocation, ventura:        "2e6c1b18e7f2309d3ff7197901b23c59e548242cf2489daca28f0b8faca44ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "dab7b05eb81397cfcb9e875a351d24d3a05741c77aaf28da7411318ef72dd770"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeec3ab80bd78902f47343a699f3ebd4566b2d3fd9ce8076550bd705caf69486"
    sha256 cellar: :any_skip_relocation, catalina:       "153d8b8e152ccf3c87041ff40739a80952da5ad06c572d7febb9b222b16069e1"
    sha256 cellar: :any_skip_relocation, mojave:         "efa83924ac8d8e07e539c6d9b3aa5d5d7440fd34bccc1da793ead1224eabdbbf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0016f711d79454b154708804c574633c48e472b9a81c257730e5cf4aa00dd220"
    sha256 cellar: :any_skip_relocation, sierra:         "5682668b2e721933054656cebc49ccb46c382428b77409d94251c6f1dfd3092d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d50450e62c6fcf71643ceaf5f33dcf4e904e389c89597ccbe148de3053839ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e4184504b5139d3532d972cad416bcd9188669c075681e36834f4e93d2b60d"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
