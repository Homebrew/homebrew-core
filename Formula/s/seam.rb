class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.47.0.tgz"
  sha256 "6ec2dd549ab90848fc811f5d503b843f56d979f26bc56a62fef7e6b8e436c436"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa531d166e3f1dde62c5576baf569de92f24ae7d93be16a99228efaba264b36b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d5ed968de1bfa274cced219a8c89b32aff1852092077229b803b0a7f846c636"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38ef9ff8f9aa47dd2fc2bcbce12f58ced34b237d7dda3a3f48036fa3a51b6abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ffca5187a64cffbab4b637a7c0f468a6af54234104d343748efe1a04f853674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4bf0499a625f95ee300c8d187da4874a7f55017cd768ce05bc8f57d7a328fd1d"
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
