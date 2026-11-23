class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.257.9.tgz"
  sha256 "5b41d7d2d5590199aa05320b9f682cce0911798722f589b47f596e9354dedc18"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "b007bcf2368851037795aea57bc28f792df22a63ef94edc41ce236695beffd89"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26a9be563b92bf41832a874cdba6968a06441a9bb1bd4475ad90ded4c13138c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26a9be563b92bf41832a874cdba6968a06441a9bb1bd4475ad90ded4c13138c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26a9be563b92bf41832a874cdba6968a06441a9bb1bd4475ad90ded4c13138c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09e9e33d822262b2011fbaa1af8117d2fdc8e376accc59db09fdb46f29e37f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "09e9e33d822262b2011fbaa1af8117d2fdc8e376accc59db09fdb46f29e37f7a"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
