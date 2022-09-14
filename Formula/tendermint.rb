class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.9.tar.gz"
  sha256 "8385fb075e81d4d4875573fdbc5f2448372ea9eaebc1b18421d6fb497798774b"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d0f6f119ae6ad63d371f13d02bb6a8e4be6c4024ba5a191a6529fed4160d780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d0f6f119ae6ad63d371f13d02bb6a8e4be6c4024ba5a191a6529fed4160d780"
    sha256 cellar: :any_skip_relocation, monterey:       "e4357081b48aa3b764e67d9e488c3c66268e6d525920ec25aef63fde5eca6032"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4357081b48aa3b764e67d9e488c3c66268e6d525920ec25aef63fde5eca6032"
    sha256 cellar: :any_skip_relocation, catalina:       "e4357081b48aa3b764e67d9e488c3c66268e6d525920ec25aef63fde5eca6032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79001a0a19c1d8e54aa1bde15b331df64620d693ee6840f9b4a8db7ec65afd4c"
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
