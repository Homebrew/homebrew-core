class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "805e0ba05534735afec06c1c8e0e93895e1ffb3388d28f17321adedacb5a0c42"
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
    sha256 cellar: :any,                 arm64_tahoe:   "32a34787a7efdef77551f395a4060dcb86c2c34b1198b060d63014bf5421b7f8"
    sha256 cellar: :any,                 arm64_sequoia: "6c25be3285bf75846741338842a0ff5629d807e8381bce24d6f75fed2431bec1"
    sha256 cellar: :any,                 arm64_sonoma:  "b71979325308049781f7e232247582dd389005a4ce2929ca5897edd5e2507708"
    sha256 cellar: :any,                 sonoma:        "2c190a84adcb95276c7c5d7bcbaed2cddf895ef327d808c6060f17ad678844b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "217ee1b3ee8d551663393a76a761927c2a83022e7168f9c25043f56994a714c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e53f7aff7af64e06ad7cde4ccd052ddb50b26d91b3a67f1b56e3c3ad9d8805e"
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
