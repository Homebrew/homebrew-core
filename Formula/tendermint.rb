class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.3.tar.gz"
  sha256 "b8c6af0ef602822889788b406693806f70e4eda1262b1532caec1f2225c55caf"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfdc2737846402eb2fce2b13252729a3f016091d21d1bae4188d8ab0b03d5d4b" => :big_sur
    sha256 "a4c507303fffdcb6f18788c366df6b50ebbe375406a8aff6cdfa7d2e9adf11ac" => :arm64_big_sur
    sha256 "e72e990d6bea4a2e3db90dd36ab4a63fa96db7999a9c499c85f585873df48c1d" => :catalina
    sha256 "c52b8e5797f97833d2dc4017f10bb64c53bce45a098518b34099e4b3800c03f5" => :mojave
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
