class Rye < Formula
  desc "Package Management Solution for Python (consider the successor \"uv\" instead)"
  homepage "https://rye.astral.sh/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.44.0.tar.gz"
  sha256 "6ef86ccba82b59edfc4f6deba39be6394e7866fe2250596b96124c20327f0581"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c1ce8ddff03d794c636fdd224c0ccf873a0a74b330d2eb3b56b7c481ccb9f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b68d8c0f567cb5d26d3ae99cacb29c56cb7cc1ef4233c73c43d554681a20c740"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc5259ed968232a6ee88fa9afeba7dd6429dc7eea4a3fafa3dc1eeda259c6a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a8e7efb4d1cb5070a3182778474e5e196f9f2e94edf30a8584de32bbe1f050"
    sha256 cellar: :any_skip_relocation, ventura:       "e15f3bbaa74bc6ef7b7fe65e79af32a812567394c27f5074f675726e3f0da24a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae95a33be1b6eab2d8e8e17e95bdb14e6b23043bfb775094f76ce61964afc2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c57f18a9a1dd66aca420ceb0bdd53d91915bfd9b93298b5cfa12411af9558a7"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  conflicts_with "ryelang", because: "both install `rye` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    TOML
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
