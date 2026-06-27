class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "63820601b8d5ad77a12e53efb4ee091d32c70950c0076af84286e31062766ce8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2890907eccb76d6fac883de0cde93c59637f5e287632237fff06686861e979ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2de667dcb5b2d27b48796f463395751f30aae7cd2009911399ff3cabef9e718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4000151c7fc9c579aa0da3eb00263f06cbc5866474513686e5ffa159f1477a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8bfcadfc39877d769e897059417dfd712c0159f8eaa35b7688ebe901990fb70"
    sha256 cellar: :any,                 arm64_linux:   "acedf2dc324b13bf0356a6fc7d1c7cc285db98c94814f2982895d2ca43fa82ff"
    sha256 cellar: :any,                 x86_64_linux:  "6508555342466f7c455e945c1c7614cedeceaeae44171129169a7b97c3dc4b9c"
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
