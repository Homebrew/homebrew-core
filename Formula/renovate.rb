require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.120.0.tgz"
  sha256 "52e0d33c24b62aeb687a99b8c3f70ad7e5653207e21f759d934c35f69129e68a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11252a74487553bc6c11843f3ac646e118cffb203b3865085537a938ab4d7e73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48c0307f035076a6a67dc791490b4b0b9a3d3ae88ad3c667498450cba67cb7ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "728ce2ea881fb95027e7ec28f1c2149d08488c2299d487a14670ad96e29b3927"
    sha256 cellar: :any_skip_relocation, ventura:        "97318da2f35f8ae6d478eda4d3fa1c834fe53ba2fe8a754cae8fa3ca601e27c1"
    sha256 cellar: :any_skip_relocation, monterey:       "7ff35ca16851137752c5bcb4616d4b05492a33f75e3ff36b519adf996750fe59"
    sha256 cellar: :any_skip_relocation, big_sur:        "f419ee30ccf1d0d82295657d918b837ed6352d0bef2e81b2efd825323aea3f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3795d1a57a0c08c266409bfb3c04f8b97460dd86dea1e07dd94911b83d037215"
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
