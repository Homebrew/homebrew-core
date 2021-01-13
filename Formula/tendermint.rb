class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.2.tar.gz"
  sha256 "6c88bfa43b86ebc63f7d5eacd0276663e2159ef4dbc7de57130815409ee050bc"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "042388d290bcb338f4fe17b494a3b7b88f7d8265917f4def5d26e584a6683f83" => :big_sur
    sha256 "b907fe7d59b9d069fa8c0d7ad3744c9cb64e66410987e3d7542ed72a0debc382" => :arm64_big_sur
    sha256 "daf9d9d25ab8cbf9684c4c796e7ce4f1bcd99a94276d60afad046ebd4cbe7b7e" => :catalina
    sha256 "b49e5a312fba9613b4c95d7966d43ffe2fce22805522d93110c2bff1bdbc9e70" => :mojave
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
