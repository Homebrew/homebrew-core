class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "c34d48cb22973c01e08692efb8df618314d94aa88b344de01fe03fb80debcc5e"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fff6360b77fab8b79b5137ea17d7bcd14dab5e0622a24f69f87746ccf2874d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616cd55f858969a6d8464aa5b9f51d81eb2a24196fa8b1bd5a2350e985356fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f2c7f1878b0c8daed9ca2c4b826c22e47060b3c98c1bb2b8f3b6a283ade75c4"
    sha256 cellar: :any_skip_relocation, ventura:        "d954822a2da98f43cb84d024118f9364b994499c852d6a0b7dd812a9eb756a30"
    sha256 cellar: :any_skip_relocation, monterey:       "e4241e74b705ab73de57ba040f60a3ffdb2ba6461d3fe04534b49115ff29c052"
    sha256 cellar: :any_skip_relocation, big_sur:        "a580eba8a1838a7e3c11a88ad31a6b9291338ead41ba9ad8405ea56713cf4543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f68c209119bc36df285a2bd92c56cafdd5b0fd72f71375c8da80cc8e9f9d751"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
