class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "94d11f2d2c8f9d99d7a1b3a05c9bacbcae016480397ed8780c6d4624ff2c81d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1669c349eb9dbf22a50e93295ef96becb867a67526e613ffe2beb1991aa0d157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c717560675eca2f362e1995e341586e613184f04e841c27ef6fdc2bd25da681d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be71fa0f2d016a0f80e54ecbc07a21f9e3cc2876b3bc614d77d0fd0f5fdcb1bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "969e3b89bf4d4bb57f1724ecffd24dd9619a30745a420b0195060ad4d1afd254"
    sha256 cellar: :any,                 arm64_linux:   "1acabc074d4d62aa613ead70fa0ed2581b054ce214419fc72d3e68c06bf7180e"
    sha256 cellar: :any,                 x86_64_linux:  "8f0c4ced8a60d812262a3abdb846e22694862408874102e221d70a89f0e5be32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
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
