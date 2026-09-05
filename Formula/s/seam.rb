class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.39.0.tgz"
  sha256 "f0ef8dc9622cec3f291484bcf9acb5d05b9bad124acf3ce2c240fda26e5ae8a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94d799155e307481df970e7788354c93d626cc546e89e5f94b3f00e4c3ac6b26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f6821a1f56230c141d38bfc647cd107141f1510045aa3713049c326acf7c13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1100b05e2435d45618075e94d7db735cfadbc3f270ec347803c25b192c09ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b12f0b8d9259bfafd11d4d26fa2d1e34cf5f09fd7aa957e63a561fb314d6ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67dcb338eac3d561fd947632f4a9773bb7c2c36d8fa58b8a447a4ffdacf1329e"
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
