class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "6ecc54253efd2bd49d55d6fd07eb24b6b0111a786375dcaa16aaf7de4bd24c57"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7bfdd01339f3c16a173a87848e5ffb291c8c6f54af4651eb4e3e4825b5412ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c87957e7e338f056a67aeb75b7de78f9e6b6f2085649ea38bbd1ca310e6c210e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d4e89b9be1b79196f3af3988f76359f1c73d0e196e643292bcad788fc23cbfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb113a209fcd9474296b928366066bd7e2b7b3123e152e6d37764d106f4af400"
    sha256 cellar: :any_skip_relocation, ventura:       "6f8debb58ac21cfff6d7d033b2a1a756761b300532c7a2cb223bb9a39eccc770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807e41dd56dfe74eae2ccc89abc241fdc11de41f56702b4bb0bd4c68c4c171b9"
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
    (testpath/"recipe"/"recipe.yaml").write <<~YAML
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

    assert_match version.to_s, shell_output(bin/"rattler-build --version")
  end
end
