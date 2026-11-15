class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v15.1/snapraid-15.1.tar.gz"
  sha256 "fb2d6a9cf9c8ea30c6962f4a48764dc9012fe61d6e23f40a8d959dadea02278b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f1549882ba69916f9c7f3c7ddb277749c18bc751886646579f41ae491b39769"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a047eb8dd44f9112fa502ad748024bf72c00378db124b704d26216c681f52dfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d25ed0988612d2afd8d4d11256ba71de192e58afe81c1df2c5822bf120506738"
    sha256 cellar: :any,                 arm64_linux:       "c1237237bc7e96f1a921e0e7647e55f27aa441897c63155569896de94e697b50"
    sha256 cellar: :any,                 x86_64_linux:      "39bf5d385bccd753c14b86a3fdda0a60b092602b51ac72f97f9e3945c78bd4bf"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
