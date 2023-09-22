require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.100.0.tgz"
  sha256 "5edddaa6701d3e2ffd24b44189a3487fadfcbf4215ec8bb913fd10cd534a7039"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "188501e44e8fe46ac5550f9bb7c9456accf55db4ebf63d227e399d7afd5f3eef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "077b6c833340f7b7ba35a4954dd3537a7b50cab6508d259577adf0705e098b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a7244126ed7a3f079be866092814b6ceda9ad18bb923a37427a19c9c86c1604"
    sha256 cellar: :any_skip_relocation, ventura:        "f822c284a6f96c8ca3392ce0be84486a5bf4b074c00014ff025ff1f279b05cec"
    sha256 cellar: :any_skip_relocation, monterey:       "aaf67bb06535a649888640b80c9ec0a3fbb7783fd580dac29447a0149a47edcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1aacc911f0f72768799b1ce6bb3a756659f8b605133cfa351b26e9549da5b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3cf366549c95fa256a5cee293ce010aa809ba27d08da1cb3146514a8fc5044f"
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
