class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.4.tgz"
  sha256 "424fb4d3769d912b04de43d21cc32748cdfd3121c4f1d26d549992a54678e06a"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e564e671fddf59bd3bc9b9aa6607f87dca58ae3fc70930c7abcf31352fa2edc4"
    sha256 cellar: :any,                 arm64_sequoia: "469c7104799be35f718cab24e9370e0acd2b77a15141d75efd2e7e552bf74fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "87c3d7eda651e267a339e0655d05cac5678f71a4658e8d9bd985e32f0555e0bc"
    sha256 cellar: :any,                 arm64_ventura: "f547c50d187df541feb087d3e1534e5537e39dcb73fbbfeea606c3659626b7c3"
    sha256 cellar: :any,                 sonoma:        "3e77a24d828c58a06b59df85b986b43ebcc14c762920f2999c9cbed7fc729761"
    sha256 cellar: :any,                 ventura:       "8d286f9e2a3568683b839d0e64aa80ec588d547dbb83ee2ad21a41c7a28c4f4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06712747809b962a2faedfc00759e579b9212514dcf17d11afbf08e73aff0626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667cc6e283e75c64c91638c8b2c667b4239ae12bcb1957cdb0e14c4dd45a1ed9"
  end

  depends_on "openssl@3"

  def install
    system "make", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
