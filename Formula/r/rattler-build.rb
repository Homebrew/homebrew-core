class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "61f6b4971c7c14667730af6c860baebb878ebba61301d0968473edd4525a2147"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d594ae6ba768806f48115626b9f0fd118b5c9358c46ef1d090cd8472e4ecfac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fef0cef1e2527f74090ed4604b027741689b239ee4f6c8676084edd670ac6f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "761703862a82f88505623c814d50ab30eb381f3dc214b73e63ba158edc110970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c3a0aa3bc60504a345993f5d6969a7d428d5ef1bd302bf83402d9d2856205762"
    sha256 cellar: :any,                 arm64_linux:       "73d59ec1ccbca030e156755c67d3504f3a573a3a212a2526090919e645a7a7bb"
    sha256 cellar: :any,                 x86_64_linux:      "640c9824957d373a34a573f0a6f74c4981ceefb8b52ca57d27ee702ab05305da"
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
