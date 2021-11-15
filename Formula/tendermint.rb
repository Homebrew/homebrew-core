class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.0.tar.gz"
  sha256 "781c34ff526e6c38fc756c1e10a695a6030086b85ba90cbb3d9f45c697464fb2"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c446caa05d5232396ea0efa1fc0181584c318c9076e83d9d6da67675f300780b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c446caa05d5232396ea0efa1fc0181584c318c9076e83d9d6da67675f300780b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd49b0bd382275d36982aae65c8b30463666ef1d83456b27538e50be803ef751"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd49b0bd382275d36982aae65c8b30463666ef1d83456b27538e50be803ef751"
    sha256 cellar: :any_skip_relocation, catalina:       "bd49b0bd382275d36982aae65c8b30463666ef1d83456b27538e50be803ef751"
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
