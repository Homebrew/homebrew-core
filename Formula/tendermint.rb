class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.14.tar.gz"
  sha256 "6202749b92b3de8220639157794fe820bea9fb6d81ad63e7649a3d08b134c0d8"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55b15c6c2e221c50f8248ab597972d313b5c99f2fb5168ade3d83c9f3cc9c8dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "47d8626ecc3e00b5a4aa01080f4fb8d8503ca4d7d124d7bb6be04099c0079269"
    sha256 cellar: :any_skip_relocation, catalina:      "47d8626ecc3e00b5a4aa01080f4fb8d8503ca4d7d124d7bb6be04099c0079269"
    sha256 cellar: :any_skip_relocation, mojave:        "47d8626ecc3e00b5a4aa01080f4fb8d8503ca4d7d124d7bb6be04099c0079269"
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
