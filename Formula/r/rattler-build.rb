class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "4ec40c823cc925f4fde510b5d43b8560b79c3cb06035407806a6d0e147d9580d"
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
    sha256 cellar: :any,                 arm64_sequoia: "6ca0286656b3a1a69d8f5cf563f919679fe520f4814a06730a60a53359d4f7a1"
    sha256 cellar: :any,                 arm64_sonoma:  "8d1a28afd30905134312e213cde7cc21ca3eb9ade3956c0b6425101d9a39d66e"
    sha256 cellar: :any,                 arm64_ventura: "2bb9958bef792dc1a31a235edd42fb00e6847a2613fac9399d16fad5f5454cf0"
    sha256 cellar: :any,                 sonoma:        "1507be23b34c6296fc289e92fe82f6904d10146331d7c60889562c7228882be7"
    sha256 cellar: :any,                 ventura:       "da28793a8d25725e5657e38732744d2432769d9c7c7156ddfe18fb69e0390bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8a80214d0b6255e23c6368ff6c208417dfe2d8d88fe14b5fda1ee893af9487"
  end

  depends_on "pkg-config" => :build
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
    (testpath/"recipe"/"recipe.yaml").write <<~EOS
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
    EOS
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_predicate testpath/"output/noarch/test-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin/"rattler-build --version")
  end
end
