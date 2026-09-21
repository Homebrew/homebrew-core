class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.76.1.tar.gz"
  sha256 "2caad9c21e3293b04ff007f883ab42f465c8e619b230baffcd2a9d88a0979071"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10389d396fb75e2ee12c0b2030270d7ab87c19fcaa83127b4937efba3351d222"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d701b518bb8a972a99c90b3f0522a65f14757e61d77347332b431170e39d28dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d52404ed119725e55bd5eac18caa7c10c3cdd5dd696ed272a0e4b358e70cc31"
    sha256 cellar: :any,                 arm64_linux:       "72b609e6da2b83980b8fddc33de20887f960e39aea1dc375ff59ab45fb1601a2"
    sha256 cellar: :any,                 x86_64_linux:      "a87eb7bb839f9f0ee25a29ee0619dc62f257fabfc074e5fd35b0c884ef33b4b9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
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
