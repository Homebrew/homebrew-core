class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.10.tar.gz"
  sha256 "3f7c45511699fe1ec51b3ac60fb753d8efb7e1ba0e37e1e597cfafb236319f97"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a973978455a9e518b9ff7319056aef35c32225e7486fcd4ae605aabe19802225"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a8166beb2fc4bec9aba75cf45526ebbb4f8d7b68dd105077023abe105dac9af"
    sha256 cellar: :any_skip_relocation, catalina:      "81fcf835463576610c2f65a6e35150ffb98ebb07b55d083f37a2cdb50a15b361"
    sha256 cellar: :any_skip_relocation, mojave:        "4988996ff563b1e2d1073ecb163b364a2fd0561dc42402887e32dbad9abc6c4d"
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
