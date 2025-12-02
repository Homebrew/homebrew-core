class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "3683d24974964fafbf37d5f7f0b1f361634d3f877aa4900c37b179ad2c57b86e"
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
    sha256 cellar: :any,                 arm64_tahoe:   "341424d79f7734149ca154697b4912a199c286c17942c09edb1e247285575b38"
    sha256 cellar: :any,                 arm64_sequoia: "e059f210999600a03f43172f7802a6cf870d75c8f965342540b6735c62667339"
    sha256 cellar: :any,                 arm64_sonoma:  "df0d8d017e8e416afacea928756f1c2617f12c9cf5ed0c355a76e36fffa48693"
    sha256 cellar: :any,                 sonoma:        "1edffd222adfd83ba99e8c792476755006cffa53979f79b7013f716cf07d2c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82302b2c909f592e0cd7d73d65a240c777a59197d550bc57f556ae621ef4833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e41168d84afe7d988e783d3a2fafbcf5a6b479266d7523082298c7a09c0502fd"
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
