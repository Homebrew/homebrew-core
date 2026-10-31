class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.49.0.tgz"
  sha256 "f93d9ac5b7d2e6d2fb9fcc7de30429a095faf2a23fe44d09cb195eea5f610479"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c1bb0d4e6ac9c7b19f98761d99c352741d640df7311a78e4f1aa79e35ca7539"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cee05ed5e51be2b5f25e9bfe7ed742760eacd1e7324b7dfc3f041fcdf12159b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5400b354dc16306383431eb621dee7620deef717b5736e3896fdc63db37bad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3ffd18407bc3c18f7cabd495be2cef98c7e06390b5db0b68c8ad9c91ba35afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "71e8743366d3bb0b138841c6343fb277428857e1376e6e366e576e159677ca39"
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
