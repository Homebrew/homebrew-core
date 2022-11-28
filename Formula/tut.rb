class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.23.tar.gz"
  sha256 "0957ce0ba09f7638deb3301989159bdf4029aeef0fbdd8ea4a50289b33d47820"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b115633c1714387247f3b6e5529263f44a86bb63fd1bfe3b672929569457b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ffa23e2181c113741927349ec9d79dbb7f468e76bddf99254124562f65490c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc139f0438c2ab2ce095ee49019076fe30528c0d4b5507ebadf370921d67c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "87c5dae581f2ec6b3a5562c9abf012ff736304ff1ec0c922b0589e8212ad07bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b227a123a692c3890f0ab0a57f25057fa61f5208208bfcb2de50a05074d8a7e"
    sha256 cellar: :any_skip_relocation, catalina:       "70d4bee708552d514582d3a82eb1e3aa9b60626a67f4b0b802c55a45e75ba856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1d6a082b40eb8a5ab0546c7672cfaf8d855444f2dd3981eeaae3c1b53122176"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
