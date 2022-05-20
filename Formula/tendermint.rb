class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.4.tar.gz"
  sha256 "9f07b72666f86afed2270789dcdff2cb3054d25038abad21091cf69ba5092768"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87d3c83ddc40da5a3ef8956393d9762faf4c2716e9af91b289494f245e9d78dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87d3c83ddc40da5a3ef8956393d9762faf4c2716e9af91b289494f245e9d78dc"
    sha256 cellar: :any_skip_relocation, monterey:       "edaa20184cfda69506f120dbd0b2b663103e484c18af26e3f8792de3755ed10f"
    sha256 cellar: :any_skip_relocation, big_sur:        "edaa20184cfda69506f120dbd0b2b663103e484c18af26e3f8792de3755ed10f"
    sha256 cellar: :any_skip_relocation, catalina:       "edaa20184cfda69506f120dbd0b2b663103e484c18af26e3f8792de3755ed10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1d7019c6d13c09e9fe1698cc305a4882e2bcde0d0802b86966907e6154447f8"
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
