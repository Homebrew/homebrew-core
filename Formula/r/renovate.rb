class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  # TODO: Switch to npm registry URL when https://github.com/renovatebot/renovate/discussions/42965 is fixed
  url "https://github.com/renovatebot/renovate/archive/refs/tags/43.175.0.tar.gz"
  sha256 "8be9c31fc4c3cc1144d60106a8d5b3d62f8e4b2934dbf9724e52ce8625f49463"
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
    sha256 cellar: :any_skip_relocation, all: "309498e0afded1d57b9b47b7df1fcecfb0c0c1d423d541275196dd8cb43c9c0e"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey

  def install
    # Pin Ecosystem union member order; z.infer emits it non-deterministically.
    inreplace "lib/modules/platform/github/schema.ts",
              "export type Ecosystem = z.infer<typeof Ecosystem>;",
              "export type Ecosystem = (typeof Ecosystem.options)[number];"

    # TODO: switch back to `system "npm", "install", *std_npm_args` when using npm registry URL
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
