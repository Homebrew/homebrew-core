class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "d7e45a1680175d43fb441cd42edb03a17209c093797655d6f79a9a74ef666823"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d66a94663f3bbd10a6b6ea1cf1713265a86c7616aa3fd2e1a1903b470bb3ffc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe7e79258c195782e5b0708fb9101d9fc0d2de8418ac7b513929451c55b0a106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "794f2769c521ad953a0e61ddaf091cce6feb7a2c9313937e1713d3cb6b849e9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b28a6b3f9b4447ae109a7b9a32fad36cbeec84eedd67dc6ebd1fc4a180b561"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498fd874e8a4d557209661f8d8aee7ee09131d982d26167b43dacf779cb987d0"
    sha256 cellar: :any,                 x86_64_linux:  "340c5e2db412f7af496f7d5ce6507dc639a56bc2360b90612a8a50e57b59bbea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
