class Urlfinder < Formula
  desc "Extracting URLs and subdomains from JS files on a website"
  homepage "https://github.com/pingc0y/URLFinder"
  url "https://github.com/pingc0y/URLFinder/archive/refs/tags/2023.9.9.tar.gz"
  sha256 "033944c58814547d240182daf8506bdf6cd0cd54b25a57212a87e2e70ec92bc7"
  license "MIT"
  head "https://github.com/pingc0y/URLFinder.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "26b43818b3c94162949546ae14e4f0cf43ca8868a7e16558ce9c7620867a93be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba0d3713537c7c40ac307a3911c7f96096a03270e8bfb029c73c37a0dbc25357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2696316763f9ba4efd365b8d76c62ff87a417b4b06aa1cc566da1f4f2b01faf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b8b469498628aa1b97562c53a55f8faea5b6337b0d546163907889f9948f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a21bbee69256af88f1c123453284c9813fe12850093bba484bfaf2f08c7cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830f418eecdb18171ff48442ed58949225c4481225181c5896ae1b87ce54c6e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6450a88906097f54b892397bbb2a421a1367836be2cf82ce1afdff1f372b6b57"
    sha256 cellar: :any_skip_relocation, ventura:        "0e126e8624e34eb2f23653cc1e5db89ca938db380214cd2a9f6638385dd41cad"
    sha256 cellar: :any_skip_relocation, monterey:       "de4942e24d0f6e39160b160bad5ecb54ad6b0e7bc02ca32eecdb91b55b0a1f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4963b3f926b8d62356802c9ab2ff6bf14ea47348b34fabc6ae32a5373a16c1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "51861ca3a9390db470a4f09fda72c026b1fe78b98bdeac07d62a71264eb9919b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955e2684479dcbbd05369e082499a91b856dd0f2f096d25d7c59a64d6f5ae58e"
  end

  depends_on "go" => :build

  # upstream PR ref, https://github.com/pingc0y/URLFinder/pull/96
  patch do
    url "https://github.com/pingc0y/URLFinder/commit/cd4b141bd92448ed4b27a1db65b05075e40e8200.patch?full_index=1"
    sha256 "e08f45c1a103125dfbaec04305f26140fe6766aa137b7a5fbe899d18efdb1064"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Start 1 Spider...", shell_output("#{bin}/urlfinder -u https://example.com")
    assert_match version.to_s, shell_output("#{bin}/urlfinder version")
  end
end
