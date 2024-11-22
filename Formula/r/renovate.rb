class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.26.0.tgz"
  sha256 "0149b2501cfc2ea9d67d46678c0d92d55b2f69aeec3cdb959237cf3c8066a183"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b2637f711fec53e354d5201905fe3f4f5b36d258a0d78b7a6333129a562d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ed06f68bfc4ebfc4d84f23cd9945d7577c4c4c931775a054fbfe232209c008"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df285323ab6537454b3902e7350291404f693ad4311630f1afb31a6fd9868cc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c034cc5c35e979cb301b7b426ef1a48f9309bec49f562302de002334c4b2cc0a"
    sha256 cellar: :any_skip_relocation, ventura:       "dff7509a740814d185ff9280f9a435453127c6a6d6a8f34ca17a626024501e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25695a2187122eb969569b43e4d71e02570f188b34a45422b27d5500e195bcb5"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
