class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.4/snapraid-14.4.tar.gz"
  sha256 "941467eb69a055028a68484c83aef6b193808914729ab3d3efe0cfd47c2352ab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04758a149ec8b1369c238f68dc262744c8935991abbd6d26eb01ead1c87321db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d048bd37a5bbd6ab7cced9ca9d6111d165b4b739f9d0f0f530451c8ffdd730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a94c55a2762b1910a7dcf6ca8efdfef3424f434069193afba8b7f3e4892a71ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a9a5eb98faed8e2d8e61296ee511cc88ee0f47f25530ffeb2b625d58508ac0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89fd8cb6a58842703cc2615f06f1b0429c3d3ac9d37504e42c5a270340635238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e08772afb3711917d822a14af952cc782b44e66235c478bc3c00ebddae9ab05"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

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
