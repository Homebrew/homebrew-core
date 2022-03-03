class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.2.tar.gz"
  sha256 "2a300b7aa6e4cb09cc77912a923dca490f68fa9c51534bf8c0ec41ea2aa2a5d9"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403dcf6461d40726404d05221f2469a76c58d9928ffe27a548b966551a7a3bff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "403dcf6461d40726404d05221f2469a76c58d9928ffe27a548b966551a7a3bff"
    sha256 cellar: :any_skip_relocation, monterey:       "b2a3475bdaa09bb9ec000b006b73d94b2c555a189b66c7e75e3851fc143c9b30"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2a3475bdaa09bb9ec000b006b73d94b2c555a189b66c7e75e3851fc143c9b30"
    sha256 cellar: :any_skip_relocation, catalina:       "b2a3475bdaa09bb9ec000b006b73d94b2c555a189b66c7e75e3851fc143c9b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5373fd5527d8cbd477cea21eaa4b735cfbf23cec61451b328f55ac131ae94e7"
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
