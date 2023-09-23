require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  # renovate should only be updated every 50 releases on multiples of 50
  url "https://registry.npmjs.org/renovate/-/renovate-36.105.0.tgz"
  sha256 "612362cc326488f12c3dc5d8048b4a7db566756b2229296c23cd4ba7230deff1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03c35d82fcfc0a6201376bf2538dbdcffef34a8ada419484e99b916e3ddbd381"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "817af74cda1aee4f4414d2e0802cb86876d83ad9e898dde5346d3267116edb65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b8a012c81edb8f106933132096bb8d244a92536f899ea56ec064f8e51459cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "828aa8a7d25c02446c1e415c21f5ddce780ecc052f76d77f95738f886f9b62c9"
    sha256 cellar: :any_skip_relocation, monterey:       "384fa7a76dd2c6db2283a3b6dff477ebcd6f1fb1f5f8e525e3f025b8e42395d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "01b4096c1cf693e74496544c73c01c5c6990027cfa262594fd20e1cc9c1b551a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe531375bd2301ff8cc97660f3f4b45d586465a7c8043b3f0a9ef619111fdf63"
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
