class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "5c0c138cbae5990210fcb2585b5c944929c8f8aa500ff4843cfbddc38176b421"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab53c5e24459f011b615f053e6e0b1f96e3b7114d222b1a88a5240e448933739"
    sha256 cellar: :any,                 arm64_sequoia: "658ca8887f2294dcb8abd0637b75e49264196e0875e00e2409a1a676bd8ceb87"
    sha256 cellar: :any,                 arm64_sonoma:  "7ca2e8b5890f525f0df3c15e47edc620a2032c1bb9b7963ae4adc878c3f68024"
    sha256 cellar: :any,                 sonoma:        "15fdf4e9802e9d987944f528aea7face7f98cf9779d84c701194da77af1b10eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39dde06ef7c3fdd150196c4bd0fdd9fe744ec2836699c16731136b0c8746e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8014149a001c455c9037c69ff78d36f355e4fa42b2a70c09d63251398883af69"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe/recipe.yaml").write <<~YAML
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    YAML
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_path_exists testpath/"output/noarch/test-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output("#{bin}/rattler-build --version")
  end
end
