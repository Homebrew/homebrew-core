class WritersproofCli < Formula
  desc "Cryptographic authorship witnessing CLI for writers and creators"
  homepage "https://writersproof.com"
  url "https://github.com/writerslogic/writersproof-cli/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "b9700174bf5232369b5e48d1ca54dbb2d855b87bce90092d6dc8fcdf4c9df3a4"
  license "AGPL-3.0-only"
  head "https://github.com/writerslogic/writersproof-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "TODO"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "TODO"
    sha256 cellar: :any_skip_relocation, sequoia:       "TODO"
    sha256 cellar: :any_skip_relocation, sonoma:        "TODO"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "TODO"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install",
      "--locked",
      "--root", prefix,
      "--path", "apps/cpoe_cli",
      "--features", "default"
    bin.install "bin/writersproof-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/writersproof-cli --version")
  end
end
