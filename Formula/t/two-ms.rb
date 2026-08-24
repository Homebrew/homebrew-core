class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "6f9fa42f8f8fcbfcb1b09c66775682a13c1d9eca2094ae80924c5ae4d779efd9"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02aa8626a16da03c41eff843c5570e7025fc04f4cf6cdfa7ba4895d5cbc174bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2bdd42c6e958ab6b7abbf067121e97503abcd437b2da6af01dba5d55a3a213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f224a7d51ed79c472873b09eec884f6c07fc58a873a9734dc54a65dfd2854955"
    sha256 cellar: :any_skip_relocation, sonoma:        "008cd8c102ab393a2494a756dd85522cb044b73f96b705aa455ab43393030180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95acb77ea9aacb9c87ccea0f65d75848dc485dd194c2aedad4d88f946569e5c"
    sha256 cellar: :any,                 x86_64_linux:  "89234a2a04377e50c7345549cf21505b35cd7d7d937ddd2d0246299682d2c9e2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
    generate_completions_from_executable(bin/"2ms", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end
