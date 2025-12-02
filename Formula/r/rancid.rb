class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "https://www.shrubbery.net/rancid/"
  url "https://www.shrubbery.net/pub/rancid/rancid-3.14.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/r/rancid/rancid_3.14.orig.tar.gz"
  sha256 "cbf608d8508b55dffb6b30c7a1c45c16ea53af7611a466e0cc47a863252f6e49"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?rancid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5978661df2baf3b746206d0b2498d27ca0adfcc840b296abe9eabfd9e9a587a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc4630246c5362304dd3550870b72f634cac5b614bb06c3a78e5b023e34397c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71bb9a547c9a465e7debae0023ea19c86247c364d4f2ac740e4ef55839f5488a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "250fd72c6d55b0cd2d34922fa16de7fc240dfdb4654679e09add571c274c269a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7cec970be7ccbed73e5b3a0a117707d1da7b884d0ce400b01cd7415acf59fd"
    sha256 cellar: :any_skip_relocation, ventura:       "972e80a0776fb3ae603f16eee01bca52199b5426737b846c5192c8529dd93168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d2743a72a538248c97c3112a9509b55296143b1142715f90c66a0360404ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4b6267a47aef7344f8e3502be5b50d7ee70010b2a452062cd976daea23c61c"
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
