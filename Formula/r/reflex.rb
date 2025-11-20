class Reflex < Formula
  desc "Run a command when files change"
  homepage "https://github.com/cespare/reflex"
  url "https://github.com/cespare/reflex/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "efe3dc7bc64b5a978c6e7f790e3d210aed16bd7e43c7fbc2713fe4b16a7a183e"
  license "MIT"
  head "https://github.com/cespare/reflex.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "730de36adf7fd1ad324ecaa1e85df9b1f064cb0491ecbc336a92001153c3265c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "188a2f2056610511ae1b9b7bbbc373091f88600c5cc28ee13eb57eaee4e21d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7203be2c2bcb77f967584006bb447f041897f78748cb3a6f8e84fd770c66016e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22412d6611b71577c603b8ce941a814c5fdf83fa8f83fd17835f2387a2fe0c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d79c8f233b6802b5b96867ce1bee7d1b933e73d2b8b3208ea680697261da62c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a8fe936c5517d03286b32d973ad16f3786bc1dd733b92fde096a6e8ada31579"
    sha256 cellar: :any_skip_relocation, ventura:        "aad285d2fecca78427be231f332fa6cf6786f422a5be10bfb1bfb9f9f3e2f174"
    sha256 cellar: :any_skip_relocation, monterey:       "8b16ba2cf36a17407a6753d3ad261cabe78f4fc32b6c2a648206279cc69285f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "88c02456efa9988132da46ce3f2aa7064add4a973603b1dcf7d78006028a9265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6016c96f2e24a11b3b75b983c0d92d5739d18e1308c52440286034255cc2c709"
  end

  depends_on "go" => :build

  conflicts_with "re-flex", because: "both install `reflex` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/reflex 2>&1", 1)
    assert_match "Could not make reflex for config: must give command to execute", output
  end
end
