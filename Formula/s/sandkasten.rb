# Homebrew formula for sandkasten.
#
# This file is the canonical template. The live copy lives in the tap at
# https://github.com/DatanoiseTV/homebrew-sandkasten/blob/main/Formula/sandkasten.rb
# and is structured so it can be submitted unchanged to homebrew-core
# once the project meets the notability threshold (see SUBMISSION.md).
#
# To cut a release:
#   1. tag a new version (e.g. `git tag v0.2.1 && git push --tags`)
#   2. download the source tarball and compute `shasum -a 256`
#   3. update `url` + `sha256` below
#   4. copy this file to the tap repo

class Sandkasten < Formula
  desc     "Fast, kernel-enforced application sandbox for macOS and Linux"
  homepage "https://github.com/DatanoiseTV/sandkasten"
  url      "https://github.com/DatanoiseTV/sandkasten/archive/refs/tags/v0.2.0.tar.gz"
  sha256   "4a1613465c7875c165a52308869983a7146512de5d35088064bd7f84d9f2346b"
  license  any_of: ["MIT", "Apache-2.0"]
  head     "https://github.com/DatanoiseTV/sandkasten.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Shell completions shipped alongside the binary.
    generate_completions_from_executable(bin/"sandkasten", "completions")
  end

  test do
    assert_match "self", shell_output("#{bin/"sandkasten"} templates")
    system bin/"sandkasten", "doctor"
  end
end
