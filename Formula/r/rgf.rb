class Rgf < Formula
  desc "Regularized Greedy Forest library"
  homepage "https://github.com/RGF-team/rgf"
  url "https://github.com/RGF-team/rgf/archive/refs/tags/3.12.0.tar.gz"
  sha256 "c197977b8709c41aa61d342a01497d26f1ad704191a2a6b699074fe7ee57dc86"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3cd71826a688d71fb47d733cc05bd43da4f3febe58031901476a7053a5e9e2fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b562241e4a197e502fe1483c9a613bb9c32c272a94583a6f8ef26a1844ed644e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6b81f03b0a52638c91d73ed4681476019f1d1ca9be5f61a2e044e48af2b6fe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c1f942c801c42fb03224c8b844b9a93c2c4b10c03f2473b0b8023336bcabdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0af19017e4f72fab3f3d8d0d76b8b3071bc2b2788c4db4dea67d2e8f5b1abe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cf3bea65341e90b931287b0171dcb3cf56368ee38d290fc8e42c58527bea22a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a9d0ca96ef4ad9c7acc3099ed638d6a88839a8fdc67751adfd38486f4eaafaf"
    sha256 cellar: :any_skip_relocation, ventura:        "3bdd9e308cab9ee5cf6f32082cad81c72de1dbdbca272650e9792b04996fb832"
    sha256 cellar: :any_skip_relocation, monterey:       "38590bb69ccb839d3e426f41c8ab17027f22e6de79fcee7eab17836f94c73728"
    sha256 cellar: :any_skip_relocation, big_sur:        "e487b14cb36a718bdf90e2b5d8fecc8850664045bdd0a54437704f98a3abcc12"
    sha256 cellar: :any_skip_relocation, catalina:       "e7865fed340b07b2bdf21c3e70fe2ec82019a58e5758e66314d0a48ba7982d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6f11ae925171c29d72b392dde35ae3b131801a15c744d29c0abb82026b5cb2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd5ac79b7dd6fb913e3ca16bdb1ca96e596f3aecd293a6059d70b1ea7d5abdd"
  end

  depends_on "cmake" => :build

  def install
    cd "RGF" do
      mkdir "build" do
        system "cmake", *std_cmake_args, ".."
        system "cmake", "--build", "."
      end
      bin.install "bin/rgf"
      pkgshare.install "examples"
    end
  end

  test do
    cp_r (pkgshare/"examples/sample/."), testpath
    parameters = %w[
      algorithm=RGF
      train_x_fn=train.data.x
      train_y_fn=train.data.y
      test_x_fn=test.data.x
      reg_L2=1
      model_fn_prefix=rgf.model
    ]
    output = shell_output("#{bin}/rgf train_predict #{parameters.join(",")}")
    assert_match "Generated 20 model file(s)", output
  end
end
