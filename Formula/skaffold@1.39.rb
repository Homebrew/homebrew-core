class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.7",
      revision: "5e2499ab4eb046cb1cbe9e73424a42bc094a54b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "671ed255285e15489f9114b68a7910097858729737d004b1927fa1bdb7012b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb52bab8fe094f49dd829e533504de1e15b9c018ae3e964ff2e7b7d2d3344d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d2d9f7c2860cdb68ec218f7da9a72a837f5b7a3ad124c109b0816288ff44134"
    sha256 cellar: :any_skip_relocation, ventura:        "f72d6b0e1fb9049daa3d5c980c5188c3568fb1be08985112d6e770968dca1d44"
    sha256 cellar: :any_skip_relocation, monterey:       "150c0958968dff2747c058909d4826126e0bafd9249f4b47d18f7761d858c7a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "52a66d35a72319fbe7829fa6fbbd04f78002509128f413a612861fe19f70c297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a9711c51a7ccf86133df4d7c2c9c8eb82dbfdf40a0ebb201b56c14318c1b44"
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
