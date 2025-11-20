class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.15.1.tar.gz"
  sha256 "101ef843524db069d54a2b8653a4757c856c6f89e3a40f40c6be8ccd8176aef4"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50bc76389f0a430737b4ff99113c5ac556673a6bf55b9479d80e3085465b1b73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60cf00e9f23e0f44edbe30a563846d6b603e4b4a82af4ef905c3a463ddd8d46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c61a25fdf65182a60801ee2c7fc104f1a923056009e6c21f24988ca1c716f939"
    sha256 cellar: :any_skip_relocation, sonoma:        "558004031692844577a3debc3a86d7ae49d108207a416825e39df7373f388438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830600159c55497adf0a72437b8cad7db021b484e7650e160baa54a223534678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1f6c321b821551b6f6c053742a2a690d88026da44953afbc92786711895832"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end
