class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "eba4ab0caac256190ad9386deedd9ad8870bb19640f3d05bf6aff899ce284dd2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e54490158a1fd1c5d86a0d2d54f7149754357202838d86754c863bec5f8c7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f594cbb2f3fc7c3597e4dc3f162d1d64976ccd20cb72060e63e5e0884e701b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf03964f9cffba949a5dc5c91598aed6b56a8a9fe5cea09c967c57c481774c77"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e611cd5f30280622cf67110be1f589652f20cc8a4d792fdf733193531ce0698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9dd974341c0a98f62e682d137e56a8e50c32b3e9d960baeb57ef256fbd98e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ff0e7d0a90d272b2798d392e5060c3f225b6acc37b05786c0b5163257abb0d"
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
