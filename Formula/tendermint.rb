class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.7.tar.gz"
  sha256 "93b7dff608f7486b8be87143f9ab50f06efbbdb30702004d7bd5dff99643e9f8"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea8a86cc8becbe0549d237030344eebdbce8220053a8f670270bb978bd4fb638"
    sha256 cellar: :any_skip_relocation, big_sur:       "53900e1a9e66b1b7069b98209c16068bb394195f823320317ec0737171f5e88f"
    sha256 cellar: :any_skip_relocation, catalina:      "8a46398b673d7b7b7b698537784aceb9b9ac03bcb8fc337210e4e8864c2e64e1"
    sha256 cellar: :any_skip_relocation, mojave:        "fe99648be3a69232861b435c8d9d8155c59d183ef9cf06d9a0147cb49bb9798f"
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
