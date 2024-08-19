class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.3.0.tgz"
  sha256 "3ae2ba96ec389eacf1d29cef2e825fae91b45aef1c395dfa1d023b7aa73f0f3f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b51ad56d1509b0eb829a8045d248c8857decedefc0867d80d93bf928cf33ac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b51ad56d1509b0eb829a8045d248c8857decedefc0867d80d93bf928cf33ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b51ad56d1509b0eb829a8045d248c8857decedefc0867d80d93bf928cf33ac0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b51ad56d1509b0eb829a8045d248c8857decedefc0867d80d93bf928cf33ac0"
    sha256 cellar: :any_skip_relocation, ventura:        "5b51ad56d1509b0eb829a8045d248c8857decedefc0867d80d93bf928cf33ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b51ad56d1509b0eb829a8045d248c8857decedefc0867d80d93bf928cf33ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4d00dcc6b20f07804e5ddea9f08ea9d95f470d8ca07d9b4e7142b4488f6868"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/rbxtsc 2>&1", 1)
    assert_match "Unable to find tsconfig.json", output

    assert_match version.to_s, shell_output("#{bin}/rbxtsc --version")
  end
end
