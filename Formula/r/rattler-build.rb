class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "cb928de61b1206642f416058aabae9db8aa8e1334b78841157bdd00843c2e0de"
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
    sha256 cellar: :any,                 arm64_sequoia: "e0140266fff2d574268f5dad05616f990b8de4ef8381d4b06e54f336724f6bf7"
    sha256 cellar: :any,                 arm64_sonoma:  "2338dd04db6a491bc908e5e0d8e3a1309266659c17ce625d11102e2ec3885857"
    sha256 cellar: :any,                 arm64_ventura: "2c621c1777d99ca284b95eccccb586b88dc2cac969321fd855f1d2b97d069f74"
    sha256 cellar: :any,                 sonoma:        "6407f289c75eb5a42b330b44845703287e45f84e5347134bd12dc0ae35f188f7"
    sha256 cellar: :any,                 ventura:       "53a1919ed5fdd62af49378e8550886ed1b0e9525ef8135018548fb80ca3ba9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf1540b83bb727f2b4bf773599cb18fb6cda79dc107233b8976e2af562dda12"
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
