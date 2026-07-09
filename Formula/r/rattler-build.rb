class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "972ac6c46f5ca839b41e8875020e7e5b2e5ecd7ae4cae613a4bb17a6175a3632"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8b058964b6085eac3707824567c5ceef6dcbcf87d411aa525771e79945fe137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "353817645a30129bb31058868d01ec16babe762035c9a27e58e9146bb216e484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b334ece340225574003855b3c1e958c70512e80f2bae68209a597a4fc24a47d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c87cf566af92ad9bea34277672ff931813e493dee4251309c73f63aca965a82"
    sha256 cellar: :any,                 arm64_linux:   "b56013a77c8fce4fa2bd5bd53763338ddaacde70aa470d3be047f98de1dfcab4"
    sha256 cellar: :any,                 x86_64_linux:  "63188fbc80f83cf11b3478fc29d97d3102fa9e7ba7fd2e0151248deb47f378a8"
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
