class Tendermint < Formula
  desc "BFT state machine replication for applications across all programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.0.tar.gz"
  sha256 "3a28fac4c5e610fc32763db1b717ec0a1e12d39262e321d6da223c3b0acfea7f"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    shell_output("#{bin}/tendermint init --home /tmp")
    assert_true File.exist?("/tmp/config/genesis.json")
    assert_true File.exist?("/tmp/config/config.toml")
    assert_true Dir.exist?("/tmp/data")
  end
end
