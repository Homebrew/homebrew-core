class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "4d8289439cd531c2e86d1ac3a603073784123386bd6409faf1461ea9e4f27a50"
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
    sha256 cellar: :any,                 arm64_sequoia: "068106d81126bac3ddd4967547a4b9d912c9eb94994e20a9382fe39d52a0a4d9"
    sha256 cellar: :any,                 arm64_sonoma:  "8324540c84f2bbfb2fa4a244055f9c6b94e2a9af30b9e92ec02c1b906b0cbb7c"
    sha256 cellar: :any,                 arm64_ventura: "ef0b9d9c9834d593a06d07160e1e977f6de982c216ed87daea5885f3619c69c9"
    sha256 cellar: :any,                 sonoma:        "d170358e08fab66127a456c82a03382fc1c30dac59a6ea066f135453d80ec6b3"
    sha256 cellar: :any,                 ventura:       "83894355a79a12a03bd7ec77cbca770031228261455917c12f3c445676b8bbcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677ffa078319f278a720c7ef6fe6f55685341d784ce5460cd8b39f190bc7be6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "585fddf53b52c7ba20d4be4f34b1b3330fb3dd20454552f8dd6e1db4d585cf87"
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
