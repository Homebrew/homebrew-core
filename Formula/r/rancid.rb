class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "https://www.shrubbery.net/rancid/"
  url "https://www.shrubbery.net/pub/rancid/rancid-3.13.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/r/rancid/rancid_3.13.orig.tar.gz"
  sha256 "7241d2972b1f6f76a28bdaa0e7942b1257e08b404a15d121c9dee568178f8bf5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?rancid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b492a1542eb00fcc51a437603be9c22d399d9062684c026ca4b13d36cc294d46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fcffc1e68b2a8ee0342ce2848d7dcd73cf3b3561351f31a0a783b1be6acae0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad23b3238d8cdef43a40e060103a58416ffb5043abd8fb94747d467357b8cdd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d22337b82b06224e0c44739c33fbc91b938168533acccde6d6c4293e6fd1e4a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b815068fba2453ad568c0406b1f8bd1b1dfe6c69891ac1301a57b01934141132"
    sha256 cellar: :any_skip_relocation, sonoma:         "018cd9ac70988abf79bb357ebfc7c26ee20cbbdf9f342e4e96b32ad12123e168"
    sha256 cellar: :any_skip_relocation, ventura:        "1699bebe63224a888ff084d1099654edb6dd9b8af6f278784bcb82a6cf201588"
    sha256 cellar: :any_skip_relocation, monterey:       "a4aeea195843750c9991c57427c79d0d0d61da7d8c0f4b7e64a7539305b18662"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c22c8b4feebcaf1b03f4feb919c352d2b449aab6341b1fe81164fa771240826"
    sha256 cellar: :any_skip_relocation, catalina:       "6840b7e2cb719007f53317491e8fe88a56820c121d52ff2bda4403bbcd0ea151"
    sha256 cellar: :any_skip_relocation, mojave:         "28b5457df20fc95e94e12925073469ba25d31924e622bfca882721fc2852dba7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3f2863b14389c488ace412c10ac68fc82dd01d6d26457c356f58d7de7c7d2d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c531340985f4299eda3b5f30a1ed7a13df5ab107dd460f8be89cd06fcdf8ec75"
  end

  uses_from_macos "expect"
  uses_from_macos "perl"

  on_linux do
    depends_on "iputils"
  end

  conflicts_with "par", because: "both install `par` binaries"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"rancid.conf").write <<~EOS
      BASEDIR=#{testpath}; export BASEDIR
      CVSROOT=$BASEDIR/CVS; export CVSROOT
      LOGDIR=$BASEDIR/logs; export LOGDIR
      RCSSYS=git; export RCSSYS
      LIST_OF_GROUPS="backbone aggregation switches"
    EOS
    system bin/"rancid-cvs", "-f", testpath/"rancid.conf"
  end
end
