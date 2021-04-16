class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.10.tar.gz"
  sha256 "3f7c45511699fe1ec51b3ac60fb753d8efb7e1ba0e37e1e597cfafb236319f97"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c01fa1879856a123a729c20b53f466465b8ebc6e1e442e21c12c981171d6723"
    sha256 cellar: :any_skip_relocation, big_sur:       "55f72fb633b41e407fdb5a0bb6ddc176376a92459cb542c37913dc9289255409"
    sha256 cellar: :any_skip_relocation, catalina:      "55f72fb633b41e407fdb5a0bb6ddc176376a92459cb542c37913dc9289255409"
    sha256 cellar: :any_skip_relocation, mojave:        "55f72fb633b41e407fdb5a0bb6ddc176376a92459cb542c37913dc9289255409"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init --home #{testpath}/staging")
    assert_predicate testpath/"staging/config/genesis.json", :exist?
    assert_predicate testpath/"staging/config/config.toml", :exist?
    assert_predicate testpath/"staging/data", :exist?
  end
end
