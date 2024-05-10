require "language/node"

class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.3.0.tgz"
  sha256 "3ae2ba96ec389eacf1d29cef2e825fae91b45aef1c395dfa1d023b7aa73f0f3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a6ed097780daf20fafdc52936033ba0619d7d79f25326eb288272c6074212b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a6ed097780daf20fafdc52936033ba0619d7d79f25326eb288272c6074212b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6ed097780daf20fafdc52936033ba0619d7d79f25326eb288272c6074212b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa56d3cc04906892b5574ebd1bb3c831d48e8e792f4af084f887bc948d12f3c9"
    sha256 cellar: :any_skip_relocation, ventura:        "aa56d3cc04906892b5574ebd1bb3c831d48e8e792f4af084f887bc948d12f3c9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa56d3cc04906892b5574ebd1bb3c831d48e8e792f4af084f887bc948d12f3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbba3aae911460dde9c44aa1d492690e7e94df7f2971aa313cb2423c06b8c1b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos libexec/"lib/node_modules/roblox-ts/node_modules/fsevents/fsevents.node"
  end

  test do
    output = shell_output("#{bin}/rbxtsc 2>&1", 1)
    assert_match "Unable to find tsconfig.json", output

    assert_match version.to_s, shell_output("#{bin}/rbxtsc --version")
  end
end
