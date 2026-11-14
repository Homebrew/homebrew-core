class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.57.0.tgz"
  sha256 "208bf6b9e10ac4643120d0807eacd70e2e88e1102398d3c903ff4b722ec63e75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c31824d00d1e7d917778eb10c046a5bdd0e41dd345f033823e86d63e0dc2970d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be28df963c419d3600c5651a760b48944d46567ff4915972405b5b0393658df8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19ee5d594f09a094598ed10021d280ccb0f813401d06e7ff378244f93914360f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "643fe150f9d9f6e1c8a0708dfe71b645498c4f22c642a741044ad0230a7fd350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "480c43b7517ba80a21d75652a749f49c38ef06f7452b1d978cb311802b54d3b0"
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
