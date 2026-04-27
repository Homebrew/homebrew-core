class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "b0b3aa0c93e39d8809a720b1364a1be9241de5eeaedf4e096645c74ba7f46ee9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19ce5a68224d58fed345b8efbc5d3150538b2fc1a1b5f9bda809441b8024bd39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0922d328d45db3d3ae28747a76f5f23710f03794f2b742d0d3b6fbb485e219c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "955caacaa3071126caaaec25be6d5f026dd0b5de54960b12129d84c3d0e55c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4da1f36a5350d2635a2d4d6baa350b5fcb27e7e5ed656f09dd4ce624ed7e8ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afdbf2ff2911f31b61579c91035209907267261e8be66e5d95e7d112e30991ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "633465790050411f4c81952bdce766225500c7a258075077583de266d2f83357"
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
