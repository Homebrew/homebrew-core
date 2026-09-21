class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.42.0.tgz"
  sha256 "9004cfe0eb089e60c774c5d70ea0621b96d59e824a2e328442c3a6880ed34bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16fd5c36293e0e83852485be2cc37944bb0b4009f017037662b09f0230c51b64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "082abb94fa3d90311e531cfecbec7d99ab9fb964183a57bfc44aef845a2d530f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bae462215b667cf2a0cf8c7c610c36f2a31dab5263fd5b409fc65d232ba1de5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77555c3a530ee8171755eebf22c9bc772f3e6dbc07306405c14e09c4fd7a2920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5977bf540212f486ea18dfcdd156d49c777304493dd36b36820f20077b434e7"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@anthropic-ai` packages
    # which uses proprietary license.
    (libexec/"seam").install buildpath.children
    cd libexec/"seam" do
      system "npm", "install", "--omit=optional", "--omit=dev", "--legacy-peer-deps", *std_npm_args(prefix: false)
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable bin/"seam",
                                         "completion",
                                         "--loader",
                                         base_name: "seam"
  end

  test do
    output = shell_output("#{bin}/seam workspaces list 2>&1", 1)
    assert_includes output, "seam login"
    assert_match version.to_s, shell_output("#{bin}/seam --version")
    refute_path_exists libexec/"seam/node_modules/@anthropic-ai"
  end
end
