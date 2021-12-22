class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.2.tar.gz"
  sha256 "7db575cc00cd01fc1e9c3bb7d00bf535ae54654d245bf994acd89eef810c94f6"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85345acd82b5acd71f203b920e446a8767464efa0936c0f0c74a4b61e82a0c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd0addba8d3057dd32038c6cf889b742b9b843cf685e03b8abf76dec590a264"
    sha256 cellar: :any_skip_relocation, monterey:       "e0907b89625ea7a62b7e4df315a1d72d2bc3e725012ede19c5a2c2663f07f429"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0b34b91c195e41e2e3a50ac0577baf963510aa4c9cdd985dd1706b3a8801a74"
    sha256 cellar: :any_skip_relocation, catalina:       "7952d22dd03b3a2982ac12dff47103c2f822b46aee35cab7bd5b6e6191f18968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38833502a774b2ad4acce38d012431e559efabeb42c9569391cca39639dd61e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
