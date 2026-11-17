class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.80.2.tar.gz"
  sha256 "752cc6c20996c7faf1af97a1e8a1c6fc8d0c1b2946e05e35c77c3a21bab880dd"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "561272e7bbe88fe566a75e56472e908090db87fa9887766b8b3ecb57e2b30013"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ce319d177a0609d275f8fb674584727b6ff1f0239aa2642a00f0cff367df06f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdb3a6619c6433be3d2d127e2d79c90a34b28a8eafbe2566419304b67a65ace9"
    sha256 cellar: :any,                 arm64_linux:       "7352d54af008d54797796e1ea3f0ab36e49ff80afb676e0538244ed0f84b8f04"
    sha256 cellar: :any,                 x86_64_linux:      "3b5913f4cb5b3fc8d854754b4dc35263fff25900c2e76a072bfabc4830a8da18"
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
