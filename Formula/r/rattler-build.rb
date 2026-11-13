class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.80.1.tar.gz"
  sha256 "172e5fc4ff9a0f9eedab0e6c572f65017f2c394e37d6dd23538f1b416cf4caa1"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a17e897a0b31914331331ebe0cb85f2aec6cf6ea1f413cb312cca2653d4f9a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc552706065767bf20e1482ef4f4d1589ebf0778edc74d0dec6abd32a56c5019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94fa5d0c57544a580e7729dcb2656d559da08fa4c86576e64e22299fa24108c4"
    sha256 cellar: :any,                 arm64_linux:       "f01040ae42e7da7e8e64d64a163144adb9475a0053a06bcae0e331698fa9f58c"
    sha256 cellar: :any,                 x86_64_linux:      "27debb114362a64010b513ecb31bbf2b63b3492814375d2fde679ba31d0be3a0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
