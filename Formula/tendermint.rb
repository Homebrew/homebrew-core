class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.3.tar.gz"
  sha256 "b8c6af0ef602822889788b406693806f70e4eda1262b1532caec1f2225c55caf"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "305ebc63c28d0b66822e201bc2551d67b5186386d7964c5657087eef20257ab7" => :big_sur
    sha256 "dbdff265a952ff04ef727ca2ef4c5537ae1d38045f103ce644f4f516c1be09e9" => :arm64_big_sur
    sha256 "434b66b1a2e9dc6fd3b363e3120eaf8d226945f89c195b333b12627a74da05ca" => :catalina
    sha256 "3a410e6879341212259a38a4078ba686910d22bb2913869914d79af3180edb32" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init --home #{testpath}/staging")
    assert_true File.exist?(testpath/"staging/config/genesis.json")
    assert_true File.exist?(testpath/"staging/config/config.toml")
    assert_true Dir.exist?(testpath/"staging/data")
  end
end
