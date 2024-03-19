require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.257.0.tgz"
  sha256 "2f5a18ea04e05d48c427ceceb213cb03d8c21292c4f1fa12aead02f2e47d348e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "897b325a0c091bc8426dc1b619b689e27b0f2bfd25ed1b57d8a919e6e7eca9e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2451d3431f6a8299fb7a5ecbba52a43ee5e05b3aebb3f51ad06b688c5809226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd30a8098d25e0ef5509663edbb57b2a64a289897683d6ef4406b156882c3949"
    sha256 cellar: :any_skip_relocation, sonoma:         "1396c39757881a8a8243be6f16e6139ea704b958d19aa7420fcc2eea5886f19a"
    sha256 cellar: :any_skip_relocation, ventura:        "0daecec86760453ec30dde6352edf98a76740f2315bf9e6321b9439775bc896c"
    sha256 cellar: :any_skip_relocation, monterey:       "ca26ceb6c150856c42df41940eeed80333f96a89660db62c5602830dcd55b5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443eb0197b0838431602bc83f2303a8a4c92a05ebabc6e0a4c4275e00e370c9d"
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
