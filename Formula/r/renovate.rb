class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.120.0.tgz"
  sha256 "c1c81f965827e0e1fc951cb7510cad535d87e208b109ed79766dae2b098f222d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88118fb2823ea0b7d70f8556b840a6ab8167a0bb04128c860b2884161718af22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d894d4e877a19eee2dd430caf95c3fa4c967e14dbc6d4e10303c18c207d4a210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "720f52d73062dc8e1d1106966a49559e68a64262fd728def512c6ea902f130a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "74975cb1e104f4a51274185a8105e87184e0615089bcc1eedb6a203dfbf120dd"
    sha256 cellar: :any_skip_relocation, ventura:       "9e8a7359b54c080fd77c9be9544de9f8777d808959ca840ff198afd4227b5c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175c1d9b4b8f52a6ff164c198a6dfa017deabcb7799e9eb21b950b068e08e0e3"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
