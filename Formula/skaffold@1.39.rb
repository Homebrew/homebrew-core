class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.8",
      revision: "eb3e89af18355ea69531ec162f1543719afe8e41"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a3ceaa8f50a68a4b4726e0e5f03468224a880c5d641e4cf1d663ba751910427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9653cd729204f872cbc74b4929e644ae077b588ef8962afcf0779655f755af7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3598a79b083ebd37292bce42f8619a515867936738ed6621bac89a335c827f55"
    sha256 cellar: :any_skip_relocation, ventura:        "73291bc83c4ede99ee9f2d08b4aac8da6791d58de380afff602a794f078630d2"
    sha256 cellar: :any_skip_relocation, monterey:       "390e41884057f8466e94d85e770566cd627755845e809cd4ec44d9befa489ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfce0dfdf06b97529e96c382582c7357ca6a6f72868da74916a4eee2472498fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39fa5d0663be7678ae769a10b8af1d103fc78f75a2057e2e41626d5b05cf375"
  end

  keg_only :versioned_formula

  # https://cloud.google.com/deploy/docs/using-skaffold/select-skaffold#skaffold_version_deprecation_and_maintenance_policy
  disable! date: "2023-10-18", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
