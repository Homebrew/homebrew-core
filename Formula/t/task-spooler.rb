class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.3.tar.gz"
  sha256 "fa833311543dc535b60cb7ab83c64ab5ee31128dbaaaa13dde341984e542b428"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c5f35adf638cba44abff07cbd38042e21015259131272a263449aec26a5b476"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19f19ba03fdec88335f2e8a84e1ef38e51fe9f00f0fb5af0488e55977d4f9860"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e03f81d2de102317e9d6cfb0231672bde2d91580eae2b87fe1b85c506ae9324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdf989b9a44ffb8b4b5d525502688c238870c12073121ceee16e6ebd0042d3c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "65b1a0b2151999624acf36aad4d7b43a5459c2953710b617a2ac86a4ca24567b"
    sha256 cellar: :any_skip_relocation, ventura:        "6c056c280eea821d1f70a3420c2a5ad1bd9946d75583577dffdcf1282b3d601a"
    sha256 cellar: :any_skip_relocation, monterey:       "fbeede406132097d9fed9b4855d16d3953ab25a793b8ec6aa839d1945d874606"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9531dbb900f39d9d773c522977efeb43f937287cfca6ef855ba962612ee9cd"
    sha256 cellar: :any_skip_relocation, catalina:       "2d714f5efbba74aed67ccf9e3b2a36c29b77578949ca33f88acd6c78e23f1f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b175e91b16a67988948e853a27ef7ecefd89c9523c09d3b2a7e375d0abe297"
  end

  conflicts_with "moreutils", because: "both install a `ts` executable"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
