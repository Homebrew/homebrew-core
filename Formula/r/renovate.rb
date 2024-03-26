require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.271.0.tgz"
  sha256 "4fae6ef5cf3fba71b240b5100be0bf77294899a5e1aab9f8b86cba1fa94e1fe4"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "066f44aef9056091c6afc694a5864fd3896708153fe6c6abb1a393ba63377605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73c8a549c66a0797bee2855b3daf10d98207cfdeb9445f5207a3d86d90a254cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca90c6d4c53e4937e11bddbd2e4004dc93e146fd8b91b99a59f186c569c66d86"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2bc65eecabf5fd7e0800e725a48f821e765623cbf1569ac4a02f4c47c31f1df"
    sha256 cellar: :any_skip_relocation, ventura:        "686a6e9764b40d21808c8fe764fed20ba8ba7577e580bd2cdcd3aa7a80682ae0"
    sha256 cellar: :any_skip_relocation, monterey:       "b5822dc81fa797389950aab838453617178deb238242224f7427ba31d66ebd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7a40d883ec93282f761e10568ab586cc53865b37bda0842705e3752582beb8"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
