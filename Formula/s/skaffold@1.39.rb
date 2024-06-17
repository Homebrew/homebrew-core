class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.18",
      revision: "56d34aca35d19614743601be84f1987ebfc2e627"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7092402e4fe734f57d06df3184d7e15e4f104817761f8e661fa19c9c5700162"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6adf6bac2313ca8f1ddaaafe621f7f22e8f1179dc2d727814844828b25bfee97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8bccd593d976444fc7294edf983e0a6eb95458ecd423e821d7c83c9e43b2885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87dadbbd6d250b0bc234d8e9b0fbe8736eed48eca653c91f511c6bb6c401ba74"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f430a5d24256caf2ed3a19724f5fcb1f045bf8a02b658304dc21d03049d7964"
    sha256 cellar: :any_skip_relocation, ventura:        "7751001a16cb86cc6fb3a2628db0985381c468b327b77987637cce2f73e4049e"
    sha256 cellar: :any_skip_relocation, monterey:       "c898cbce0414a84ef0770005e502a53638b3598eb9ade7ee49b2f21fe1a9ed70"
    sha256 cellar: :any_skip_relocation, big_sur:        "86311586a6bdbe20b5e059cd2145315230cd4dea0e8a5453f274aac545dcc52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2aa6324b26f27f6b0098d00c14cf84490154df61cd1d573f35ef969554ae028"
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
