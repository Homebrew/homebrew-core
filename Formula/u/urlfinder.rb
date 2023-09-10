class Urlfinder < Formula
  desc "Extracting URLs and subdomains from JS files on a website"
  homepage "https://github.com/pingc0y/URLFinder"
  url "https://github.com/pingc0y/URLFinder/archive/refs/tags/2023.9.9.tar.gz"
  sha256 "033944c58814547d240182daf8506bdf6cd0cd54b25a57212a87e2e70ec92bc7"
  license "MIT"
  head "https://github.com/pingc0y/URLFinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b8b469498628aa1b97562c53a55f8faea5b6337b0d546163907889f9948f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a21bbee69256af88f1c123453284c9813fe12850093bba484bfaf2f08c7cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830f418eecdb18171ff48442ed58949225c4481225181c5896ae1b87ce54c6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "0e126e8624e34eb2f23653cc1e5db89ca938db380214cd2a9f6638385dd41cad"
    sha256 cellar: :any_skip_relocation, monterey:       "de4942e24d0f6e39160b160bad5ecb54ad6b0e7bc02ca32eecdb91b55b0a1f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4963b3f926b8d62356802c9ab2ff6bf14ea47348b34fabc6ae32a5373a16c1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955e2684479dcbbd05369e082499a91b856dd0f2f096d25d7c59a64d6f5ae58e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Start 1 Spider...", shell_output("#{bin}/urlfinder -u https://example.com")
    assert_match version.to_s, shell_output("#{bin}/urlfinder version")
  end
end
