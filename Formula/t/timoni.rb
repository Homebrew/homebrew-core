class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "b7c98986ceec18f40a6ce96845c125f042e84668dc765c306dcebe7e3b87fb64"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27a589f697545abe06ee4a62efa53a8400b87f78d31299f28b4aca7ea688f3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1be2a65fcd0d770342ca4b7c48bdb9a8a567fe73fbcfed0a2e63d96ab907bf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16e6daedc4c8daad4db381f1c752acd8c1aff68233a4dda07f763ac606d7cb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09399b521ba16f723775df72be406c6352a8854e52e0d92d667aa1d761133a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f512af2f855d03924f8e3943e0c916e24b55e7252b652e2398ce849af6d872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "131f9788d8ce589c1e82081829cd5eba1f3f78e9d9562f806a8c28b2fd2719c4"
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
