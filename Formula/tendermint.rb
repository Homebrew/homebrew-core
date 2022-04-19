class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.4.tar.gz"
  sha256 "9f07b72666f86afed2270789dcdff2cb3054d25038abad21091cf69ba5092768"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e963f8f1c2703eeb438eae89cb4137b71d6e7b807cdc5034c949b2e3e3a80163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e963f8f1c2703eeb438eae89cb4137b71d6e7b807cdc5034c949b2e3e3a80163"
    sha256 cellar: :any_skip_relocation, monterey:       "a9724d7522cdbf6f5037cf63909f3ad8d2b9993f5dfaf53d8240a6419782b906"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9724d7522cdbf6f5037cf63909f3ad8d2b9993f5dfaf53d8240a6419782b906"
    sha256 cellar: :any_skip_relocation, catalina:       "a9724d7522cdbf6f5037cf63909f3ad8d2b9993f5dfaf53d8240a6419782b906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a94a17cf104ce7de3e805eda366bf3f05535a906060b21e53380d7326222a9bc"
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
