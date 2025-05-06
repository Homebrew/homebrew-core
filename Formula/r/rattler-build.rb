class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "dd2192b323aadf42364543325e632f81b90cf8eff74f0f5029cccd940cc8da49"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa23ee67f4eccb5603b3185e12e76aa5f91b94793bac64d13dfd86efb478674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4bcd4e9fe992cf98768558c0d8d5ab2450f0b943b1035107e23bd0be58fd2bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88e6df08c6c261e1cbe74af6017fb3cc1fe598e04a7ac8d5331af52e2f2bf68d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5da80624f70937df31589d4e0077707444b75df728da54b86bcbc44767cbd31"
    sha256 cellar: :any_skip_relocation, ventura:       "fbb27b6828173751cc007c12ba477c9036f5838e1fda15dda26ab4cf2967e0c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd8e712ae8194d5e99dafd1615c79513251d4e7d537e77a3a33648440ce39098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5841b269589776502ac1a7702df758eecc62a6d4b046b6850f78693a4a6b412c"
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
