class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.7.tar.gz"
  sha256 "93b7dff608f7486b8be87143f9ab50f06efbbdb30702004d7bd5dff99643e9f8"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6dfb9c85d2d66a7fcb48647e265d4e4529b1e40fe145911111df7a183707405e"
    sha256 cellar: :any_skip_relocation, big_sur:       "53411911ab4e034faad9342d53415c39a2fd460fa37d73fe9294b1d87c776a72"
    sha256 cellar: :any_skip_relocation, catalina:      "a370c3ea1995db8c286cf24ac3ba2e836084eb1f25ffda1d100b7e9b27d7b0f7"
    sha256 cellar: :any_skip_relocation, mojave:        "9cc3f5841f98e70da97396cff0ba2a7683120dfc03e8314097fb35cf87ee52c9"
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
