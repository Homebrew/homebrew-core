class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.9.1/sec-2.9.1.tar.gz"
  sha256 "63a4125930a7dc8d71ee67f2ebb42e607ac0c66216e1349f279ece8f28720a34"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b9e876b09cdbcbf85df22111dfc2e9bc686dc8df21b791f8a532ca8a3794098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b9e876b09cdbcbf85df22111dfc2e9bc686dc8df21b791f8a532ca8a3794098"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b9e876b09cdbcbf85df22111dfc2e9bc686dc8df21b791f8a532ca8a3794098"
    sha256 cellar: :any_skip_relocation, ventura:        "30b242f22b62c67d6b5e862fd9884ec05b327e33ee6d146137b3566e0d2a178b"
    sha256 cellar: :any_skip_relocation, monterey:       "30b242f22b62c67d6b5e862fd9884ec05b327e33ee6d146137b3566e0d2a178b"
    sha256 cellar: :any_skip_relocation, big_sur:        "30b242f22b62c67d6b5e862fd9884ec05b327e33ee6d146137b3566e0d2a178b"
    sha256 cellar: :any_skip_relocation, catalina:       "30b242f22b62c67d6b5e862fd9884ec05b327e33ee6d146137b3566e0d2a178b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b9e876b09cdbcbf85df22111dfc2e9bc686dc8df21b791f8a532ca8a3794098"
  end

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
