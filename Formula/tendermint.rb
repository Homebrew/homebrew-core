class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.6.tar.gz"
  sha256 "95de8d59c7a5eee5dc6fddc76e0eb68a9c649a92e54559ec73851b41e381f58d"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b05014a7dea5af89e1d62ca69bdc287becdfbddda926116e876c6bb69efc38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32b05014a7dea5af89e1d62ca69bdc287becdfbddda926116e876c6bb69efc38"
    sha256 cellar: :any_skip_relocation, monterey:       "cf3127d054df61471ac7ef34bf3a6a202d115a880f10c178612f4d8a7c022986"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf3127d054df61471ac7ef34bf3a6a202d115a880f10c178612f4d8a7c022986"
    sha256 cellar: :any_skip_relocation, catalina:       "cf3127d054df61471ac7ef34bf3a6a202d115a880f10c178612f4d8a7c022986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8938f4ac3a626c4a24ad6ed9ab7f533945f58ec8d35bae85fba17c4d1ebfc1"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init full --home #{testpath}/staging")
    assert_predicate testpath/"staging/config/genesis.json", :exist?
    assert_predicate testpath/"staging/config/config.toml", :exist?
    assert_predicate testpath/"staging/data", :exist?
  end
end
