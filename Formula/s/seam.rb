class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.49.0.tgz"
  sha256 "f93d9ac5b7d2e6d2fb9fcc7de30429a095faf2a23fe44d09cb195eea5f610479"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8bcf7bf6f7fef3324b2432b1bc91522dc0971b60fdad51665b4dfa58cc193b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8494dbf7c41c5e519d0f319a1b428bcbe62c6fe3e80e18cc38caf689c45f476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7b13fd05e553960218e76b6b494c1ce1b69a2f22d7e3bb48722369b6a3d7008"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a37fe789575a82c62c5a3ce1c75356108d58c08ec4114ff7d7df975c5d91c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d8db180897f690d63f46e7c3183202bbbd594df99e7eff1ba592512b3251e119"
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
