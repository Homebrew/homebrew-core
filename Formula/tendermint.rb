class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.7.tar.gz"
  sha256 "d56fa85c67239c156f849d8295a5f8c660eabecf3407674f0fc49fe68b1d3748"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a2b7f5fe4bf975f6b4a5b9247304c892dace84cb37c02d43447bb5c0d1212d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4a2b7f5fe4bf975f6b4a5b9247304c892dace84cb37c02d43447bb5c0d1212d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4d4784a84eb1b5499e3140660fa1933ae8536da4e596134b986e1676ddf8c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4d4784a84eb1b5499e3140660fa1933ae8536da4e596134b986e1676ddf8c45"
    sha256 cellar: :any_skip_relocation, catalina:       "c4d4784a84eb1b5499e3140660fa1933ae8536da4e596134b986e1676ddf8c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34156bf52a395bebf22fe3273f0341f023725731f35574ba7234f0fdcc916d8c"
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
