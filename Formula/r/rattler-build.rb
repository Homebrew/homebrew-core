class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "af7f0dcddf07d2e3e8eb19dbed72bf3951d7ff3628449ba76173a70cb9840176"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bffa43263a3907d67ecc04cd3e8a16e6128b1f9034b281eea37b32f9715bdfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3088c699eb57306323ee9c33e41376db684ef8ac053a785d09138907df63cf6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323ee7226f0f3fe8956cea9376b83c91b93db66d416622d497eeb71678a26ed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fa85a562c5baca43b0fbdcc395623eb0755e18b149712e071ee3f5f952aff57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c397e592ee56027c7732b74fb138bd06aecba1e0807e8540645f11856332d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf3102ddbac00d5d294c1ec1e12a2b6a72fdb40fea5ac20ac20db7c2cbf2c1c9"
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
