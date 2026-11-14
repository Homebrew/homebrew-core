class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.60.0.tgz"
  sha256 "5148bd00e93ae65a7bbc7ca96a6f2850f6ab87d6d79f57dd4b4c935b8b6d23ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fca55a27f01847932a0e31d047d6d2fe377320ea2e32cd784c4b2e65d12414fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5776e248c793147f00b46b19080a1402107c6044e5b70ed691b8ba476db3f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53bb37a4c8ff3f0e47bfce2af52178b4321b679825bd56a2c2a2b7af365743f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e604169cbe5d6fa7bde60b02bc5cecde5b7e194df3f8dbea761ae1738cab3e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "54b077e5c27fd23f92e5923884e227734c7fa5500f7145fb2c04c6a2f7e05866"
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
