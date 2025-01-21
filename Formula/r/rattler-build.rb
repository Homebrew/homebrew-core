class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.35.6.tar.gz"
  sha256 "c978c372d25fc29c922e7af82deb15337bc3961721ca3fb5da3804f460a4b02e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5af234d68ca2a8f7fe32f1a0687ca2b0d9398c4d76c1defb76f417fa94d4aa9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648f3f504a04eb8a95605d5bbc6dc89d8690d3da9c1987fba0f8394a60320103"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41a2f8514eaa2637a0362a6fe425bf2385c8a9be75c06a0c18ebb38c847af758"
    sha256 cellar: :any_skip_relocation, sonoma:        "819891ef0776490a685de05d456f36197190099cdfcc1b64c3c712fa3a4040f7"
    sha256 cellar: :any_skip_relocation, ventura:       "1a9bd1bfef4d55660d929a31c25504c4ad88f1ef762a30ba6a6e3afda172a014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc25554d3990d11aa3fcf58b510023e8760fe6464baf83c9cd056ad88e0a1ab"
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
