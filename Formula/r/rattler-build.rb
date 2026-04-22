class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "dcc92af75202853459f942a9bc4f0568c0586828fccb6765e3bb38486f206d15"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1d7c94cdc37a5280a48e2eab66c06b5c351639ea6641fad9d078fc56dede743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1afeedb9f799f65051e88d570456ccab102e2b2b47c7681e2f4b1e3c524507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a66eef4235bfb2d72da32beabfa82acd186adc01ef65c88c000484f0d03c75d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bb67f2c8f93d6ecf84d08a857a0139409a83eeb584970f2550952a0bcb07415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a31c6f669f814928e7294de9e29568c0ca29d75443b9b96e4325487273a981f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f820651d3651ac95ed410367352de40027eba15942595104cc9cf4d594478fc8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

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
