class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "9da7dd6d0c86ca5fc0eb06768a9edaf7288a54c936f2d20f7923fcaf705e96db"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745f043e9604e591cc68b411e0f591ae4d1bd3a08637f3b495c2facb184e6e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae448e4be265b10f36c9094d6b8fd16a2e6c0f7302bb5de6cd77cbe10071043e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a84e5946dc0850879a4074e94f9570c2d09c1b9cacbd0485991cbb58711ebdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "82662a192df594899154b957d69baf23ebc803cc35cc46386fc1e6b55fa673d6"
    sha256 cellar: :any_skip_relocation, ventura:       "deda79bf1ca4e2d90d625fd44203a3c2ad5ee3518d0166d867cb11ed39c77c04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "197455a4a716aded8a42bdf5de4d58fef5783d64d8f6ada7618a4be5ce862636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "127d67da8c48e4f0c9fc4b31c7111074d12b8a0aa75ac32a465d91bf6497cc36"
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
