class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.144.0.tgz"
  sha256 "25af1dcde3ba47b088e7017862aa15d1a32c77340d05e77c0feffaeeccf94fd7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aedc6b3c9d01c102558ff93ce7e15fc9c0349b8ad67d2256fc5b4c054bbf56d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2ea51c98727dde179c48592673d68dd9b31b5e3975ec71fb71098fdccb04de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb9cd25f8ef1a3dcec7c1da556ac20258713e65b99cdea10a605f0793e29d0d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "19869079ff96bfce4f5775886ebad8ace772ab7d0c948f07a23d842375cb9b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7bbcc69d7765f47cb67a3ab7fa003441e244f6bc380248c8d46fbc1da298956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e585e53acc169736f0e5693b7a7f67e4e0c0b6ec32d517a85e156e862ee715"
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
