class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.201.0.tgz"
  sha256 "529440d1427760db1389fe2f5a5f9ed3120556a65dc74d68bc5bc5adca4d12f5"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36f4c0ac8b602ecf4ccd9302584709fc238c39ac313049e347070e8684eae408"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36f4c0ac8b602ecf4ccd9302584709fc238c39ac313049e347070e8684eae408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36f4c0ac8b602ecf4ccd9302584709fc238c39ac313049e347070e8684eae408"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6774ae308ccf3d115bd39b2a284d129f45822e8962f01e414aa0813cdd518ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6774ae308ccf3d115bd39b2a284d129f45822e8962f01e414aa0813cdd518ece"
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
