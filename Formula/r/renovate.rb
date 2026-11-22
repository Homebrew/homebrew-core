class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.257.7.tgz"
  sha256 "86b9d8f32a655d9a84a59fe9ef4cdb70cd4557ec696690fd3797b0225b88dbae"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "db2bc7545e12a43e6ac715f4940b8026d890cdaa973db4cb1732ae687d2e7fc5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a1af3b7bcc9a3b61d1981e63d7f4ec4f45083cb01e389e87497f87afc6f6b86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a1af3b7bcc9a3b61d1981e63d7f4ec4f45083cb01e389e87497f87afc6f6b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a1af3b7bcc9a3b61d1981e63d7f4ec4f45083cb01e389e87497f87afc6f6b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a683326efd52f6f934c6f9d7ebedf5ec2bb79e314071e7e7abca409ffcc00dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a683326efd52f6f934c6f9d7ebedf5ec2bb79e314071e7e7abca409ffcc00dbe"
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
