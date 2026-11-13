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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5a4ac59fe1a230fa671a915af4697f780d0516f573d7bd32a8d4f943927e94b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4236120abfb4d73426f3d56e04bd901fc14b10c4a1eff114478a24f0b5eb24a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c4cd886979c9fef71ed23d2f84f0a617f5ce3b007f5269aea346882cd3c3b7c"
    sha256 cellar: :any,                 arm64_linux:       "cd8776a1dde1c4272fd4ada7e05710e0494d32f6e360da599e1edc618e777154"
    sha256 cellar: :any,                 x86_64_linux:      "d6dc1834b572182d605371f9e66f001979879f603b89047962ca1cf929871751"
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
