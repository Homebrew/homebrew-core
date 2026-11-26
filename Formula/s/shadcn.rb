class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.23.1.tgz"
  sha256 "77b90293fed975ed3435d5a0ba9fa93663739703a446df465af6a22d9d1e18b7"
  license "MIT"

  bottle do
    manifest_sha256 "b596e3edf150d7a1d7adab03a3f7ff38dd66e9cc0bcb20764536439caad3124d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0260e2f0a036a175c3a9a171383c29862d924cea79b5c4f413b750a1ebe0572a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0260e2f0a036a175c3a9a171383c29862d924cea79b5c4f413b750a1ebe0572a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0260e2f0a036a175c3a9a171383c29862d924cea79b5c4f413b750a1ebe0572a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6eff738b2067043ca05c94b1e5b1e173f5f53e01d91401253847fc2c20ef29b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6eff738b2067043ca05c94b1e5b1e173f5f53e01d91401253847fc2c20ef29b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
