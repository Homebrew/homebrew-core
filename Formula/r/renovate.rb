class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  # TODO: Switch to npm registry URL when https://github.com/renovatebot/renovate/discussions/42965 is fixed
  url "https://github.com/renovatebot/renovate/archive/refs/tags/43.163.0.tar.gz"
  sha256 "d97fe26975503b6358579eb867e12cbd046c7edc17d1fb7f0ae88b4539174648"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f697f6228c1ecca47291066fe72b7be69f3d43a1993286f2dde0ece99465f14"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey

  def install
    # TODO: switch back to `system "npm", "install", *std_npm_args` when using npm registry URL
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
