class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.8.tar.gz"
  sha256 "81b37134869e10a54c152a554a2251fcdb871d15c95e85e62f9d8871670dc1e6"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "792392e981d6841a437e040b6ea85fbdfe1d9c5b77a4aacdc94ffc44f5cb52d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "27c98ea6cb01286c513a15a1ba86bfd1693ac6aa30e2179187edf28f67ab87dd"
    sha256 cellar: :any_skip_relocation, catalina:      "68dd51ae8dcc184e6c3ae064380cdab4e1be197270f335583f3ac7b0fd664a68"
    sha256 cellar: :any_skip_relocation, mojave:        "a8b8b60534b8e23f172962c81c4c3b11e423c64fb2d3adbc0d50f833e45b13a2"
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
