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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2baca1297aa4d7a97941b828af95333ed64e838beeb9adc04ecedc2cb2a1d356"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb3811f950f327c2350fa99246bcf497d1251ac8decce435e1ee478082dc292e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924f033ca49586c79e8982864039526bfc9fde74c37c0166f82e43144c42ceed"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ccc67e0f116f6753cb59e9e17720a6e7deca5cf98063dfe17fb14a0ae89e014"
    sha256 cellar: :any_skip_relocation, ventura:        "77e11e304ad00bb3712e9f7ab381b0252277d86a89dab43c55da718ad083bdef"
    sha256 cellar: :any_skip_relocation, monterey:       "098c8c3f4fb1f0f1f07183a0acf8ba350c1d42285293a28f4a2b3997ad5b7a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29b65b680758be3154556ab005a5e8f4106a55f3f7d6f5b1768cedf802d7ce4"
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
