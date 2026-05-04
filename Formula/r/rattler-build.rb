class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "46546d11a32d97271ff3e11719c017e7050beaa999b1d4c5dc2ca6ad402e7f02"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a44e76c31d3df12f6af7131e3c7ca1d7daf02afacbd7632927da89ebb47f0947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bccb98ba0b571960230875dc86292b1edfefac9504a70ba3a68c810081e63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf44c2a926d164627c32244a63bd53812a624a6f4b9e565a8978cd11283f46bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8c1d7a373048e94a4da3ccad3ee12d94aeee16fbf18c26df144f79494158e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d404e54b4d8de63f7062228f22d3cbb95bac4e7f9ee4934d07ddd54fe2fad55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73327b74668affdfae35e3d1b8b5010eb0045dfeb0b78bfffe816f1164513097"
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
