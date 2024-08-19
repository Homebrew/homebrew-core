class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "b71449df6aa575ca9ffc24a154f208e725d8b2ec11f42d59e8215162879806f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61c34d2ac0b7cd9cf28d66e7c3b2d9e8e84c21977311adeb099218ecc916d4b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "429f081dfd4c86741fb1a67e98403a759264b78610a87ab072d7539ff115dce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09b3deb94d5c3af660afd8a4ad4b77c705e202809036f234199afda2c22c728"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d2ee50ef975b561ebed9586f266d341ef2b4f12e9673499aeb870cd03ac076"
    sha256 cellar: :any_skip_relocation, ventura:        "f2c421275a48239b812d152a063bb2e7a00f0b17d7f06bc956e9fd734c9e24bc"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d141c2a966ec95b72651bcffada6fe57093edecb7ab61523c522ef16582293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f095836e362d28a577dc2541d6edcdb84e2586e0b5ef5185aa4ebb32a865c5b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
