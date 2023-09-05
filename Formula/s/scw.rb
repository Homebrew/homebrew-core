class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.20.0.tar.gz"
  sha256 "d66fe3f13a1cd8f48c601e2370a7cc5b5f7d7e64b22737f005e8de55062ff5aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "592823d617c7fe0cf4ed45f2f73c998d1836f41745d549d2e60ae08b7bc76a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7503c3347018e93782bd6c5b81051be2360cbff8001c86e7f31a025fc6f48fbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26c95944a20e2e236fa5379e30127de197fa5c605d7f77a6c47e577061f35a92"
    sha256 cellar: :any_skip_relocation, ventura:        "0b89d980192674bdcd9bcfa1fdb4c683d857daf5db3f8e276c07aff1359bb151"
    sha256 cellar: :any_skip_relocation, monterey:       "71a7ee657354613d07f29226983f35689688d3399d2afd6fb0e0020952796b5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b82a3663529e79c5dd18f063c3131cc312aec4797d4b15a9341ad8ec3d3289a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accb02c13354461fea3eee5f003bd58ea9e18bf6199e8f40477f2ad62c7e9ad8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
