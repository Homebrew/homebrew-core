class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.225.2.tgz"
  sha256 "81904589494fc7a228a8cbc3cfa73083da7a5d2d1144df495c4f9815c0bffb24"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae2678dc6bfcb30853946e86921eda83fdd9d67618e75e1a63724f0d01ad475e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae2678dc6bfcb30853946e86921eda83fdd9d67618e75e1a63724f0d01ad475e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae2678dc6bfcb30853946e86921eda83fdd9d67618e75e1a63724f0d01ad475e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28df9c05658d10d76a4c704170f111a0ff147cca2e50c08d2a43f86c5fb9fe14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "28df9c05658d10d76a4c704170f111a0ff147cca2e50c08d2a43f86c5fb9fe14"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

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
