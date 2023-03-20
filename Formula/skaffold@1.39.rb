class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.5",
      revision: "64f6ffd59dd1c76e73ae41cd81a712cd1726c5e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3dcf7ccb531dff534312e5d8d589ebb95b21e0420e60541165e683c6c782768"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b08d1aec4fe1c94d3a52005113898319e024774f02e0478c80830d49081bf4fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ae5079fdf8d3ce61dfc7e279ad5181d13073928ad383d29c5161560a23f7c44"
    sha256 cellar: :any_skip_relocation, ventura:        "0326fd3121a2439c6ae85cebbd24444a4e341cf91365f4962272d20d055a8ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e83f7c9115c006354dd4170fbdd038afbbd1cd6d731f270fda4118055ccc9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "667bda6c059d20ca758c7a6fadec439b9ffc08bae24074a85c4032fef8f6f55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c2bbccc1190ec4375b3cd4085dd56352c17958ba50bf0a9dd836f871f96732a"
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
