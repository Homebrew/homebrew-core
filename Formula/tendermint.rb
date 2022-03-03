class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.2.tar.gz"
  sha256 "2a300b7aa6e4cb09cc77912a923dca490f68fa9c51534bf8c0ec41ea2aa2a5d9"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2413ad4ad056b32627c2b3b0a02a12fcfeddd4a47924bfe917eadecd3edceb93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2413ad4ad056b32627c2b3b0a02a12fcfeddd4a47924bfe917eadecd3edceb93"
    sha256 cellar: :any_skip_relocation, monterey:       "d575717959d09a1bdb54cb5aad76fe0e64153bf6d19b3da732af2183ac689cbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d575717959d09a1bdb54cb5aad76fe0e64153bf6d19b3da732af2183ac689cbc"
    sha256 cellar: :any_skip_relocation, catalina:       "d575717959d09a1bdb54cb5aad76fe0e64153bf6d19b3da732af2183ac689cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5706e2a4287571a080412ddc7d5d5e4b53a43c2d63a82a2e4f3ea57191c88be4"
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
