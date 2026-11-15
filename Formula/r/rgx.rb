# SPDX-License-Identifier: Apache-2.0
#
# The Homebrew formula for rgx.
#
# The package is called rgx because that name is free in homebrew-core: the
# one that was taken was the crates.io one, which ships as rgx-search and
# installs the same binary.
#
# The URLs name the macOS archives Homebrew downloads, and the digest
# under a URL is the digest of the file that URL fetches. All of them are
# release data: scripts/push-github.sh rewrites the URLs, the digests and
# the version when it publishes those archives, and a rewrite that does
# not move is a refusal and not a warning.
class Rgx < Formula
  desc "Search inside everything: PDFs, Office documents, archives, 3D models, checkpoints, databases, e-mail"
  homepage "https://github.com/danalec/rgx"
  license "Apache-2.0"
  version "0.1.11"

  on_arm do
    url "https://github.com/danalec/rgx/releases/download/rgx-v0.1.11/rgx-v0.1.11-aarch64-macos.tar.gz"
    sha256 "543bd1cfd53c9ebe44c53fa0f3c84cae452effe65d1dc6dcf829781b473c384b"
  end

  on_intel do
    url "https://github.com/danalec/rgx/releases/download/rgx-v0.1.11/rgx-v0.1.11-x86_64-macos.tar.gz"
    sha256 "5144339409954459309c595573bf0a2dffce2617c610bb1710a045339a839da2"
  end

  def install
    # The archive holds one directory named after the release, and the
    # binary inside it keeps the name it has everywhere else. The formula
    # does not depend on whether the extraction keeps that directory: the
    # binary is found wherever it is, and a file that is not there is a
    # failure said out loud rather than a formula that installs nothing.
    binary = Dir["rgx-v*/rgx"].first || Dir["rgx"].first
    raise "no rgx binary in the archive" if binary.nil?

    bin.install binary => "rgx"
  end

  test do
    (testpath / "invoice.txt").write("invoice\n")
    out = shell_output("#{bin}/rgx --count --no-filename invoice #{testpath}")
    assert_equal "1", out.strip
  end
end
