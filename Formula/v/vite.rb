class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.4.0.tgz"
  sha256 "db2e7150615e404440c73407bf5d01764e572beeb71367c9ff96d97b84578953"
  license "MIT"

  bottle do
    manifest_sha256 "3e0ea23871988046d640e24968cf685d9cd1b94867c69487bbdd1100c68dfb9d"
    sha256 cellar: :any,                 arm64_golden_gate: "e1921ed65d47365f692c16dad10af040178d07bb49891bb14ab9d2d76db137c0"
    sha256 cellar: :any,                 arm64_tahoe:       "e1921ed65d47365f692c16dad10af040178d07bb49891bb14ab9d2d76db137c0"
    sha256 cellar: :any,                 arm64_sequoia:     "e1921ed65d47365f692c16dad10af040178d07bb49891bb14ab9d2d76db137c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17ef981048a9540d859258a5dc992af48ab7f13f2748111fd2ff205b117c896c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9020992cee5331f491615e1e2d049ea052a07f252c10771a2925e6054e549e01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
