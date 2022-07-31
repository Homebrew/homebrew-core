class Rpg < Formula
  desc "Ruby package management for UNIX"
  homepage "https://github.com/rtomayko/rpg"
  url "https://github.com/downloads/rtomayko/rpg/rpg-0.3.0.tar.gz"
  sha256 "c350f64744fb602956a91a57c8920e69058ea42e4e36b0e74368e96954d9d0c7"
  license "MIT"
  head "https://github.com/rtomayko/rpg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47a98b77d2c445d34d87f93b109634f195e50b3261ffe367b61536e5d97c806f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ba9343282027a7a1d3c6422920bf0a52c4e78fd11698781228c6f01a07eba9e"
    sha256 cellar: :any_skip_relocation, catalina:      "d1d4031e3e641523f759f3c2dc69fed0cffdfa537639c1f9686ddc7763b93df9"
    sha256 cellar: :any_skip_relocation, mojave:        "fab3d032e629a4d20add14e9693919a074286990a16eb6fa8772180fc60730ee"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f1c7e5d997a1f0ceb1cca6b1067408912ff8e14522fb411530649f0689f9d042"
  end

  disable! date: "2022-07-31", because: :repo_archived

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rpg", "config"
  end
end
