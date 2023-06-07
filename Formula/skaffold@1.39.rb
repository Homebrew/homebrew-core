class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.13",
      revision: "1d98ed557729fe4f8294bdb502359cfb28e9cf1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa59d77d40df70a04c29efc6fe42c273072a26d34e074549f98d27a52911ccb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "981452ccd2108c1a226469d3d4c6cc64862910cba3e5efcee344f257be50cfa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f25ad9acffed2c9104d5e2c1de245e936c377373f91906341a77baf2f6a02b0"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba2a685bc28153a367ef9613efcd012cde237dc7ec6fefece8027acc147c11c"
    sha256 cellar: :any_skip_relocation, monterey:       "1f0110caac7e69b22f637a23cef4c772f61ee538970ddc8e8c335c32d466c6d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "875c3fdd81332171720fb0f81c81c742c68a5d2e556cfc1b02e0175c216f97bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a919c64d4617f6843808a21a3c3f94468ae51ef488be51796d3249a2d6d52d4"
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
