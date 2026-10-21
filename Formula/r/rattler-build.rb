class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "7ca617a029b128e61a4b9e77fe02ba6c8291a9ade0490ef304a1f6fd265b80a8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "414e1577c443ca1c784c2da85e8b39da153f8e43a87564bbb49b943312c69162"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ebec6bbfd0930aeef25b86c53ce1687e6e4736c61b357baab91449b2f5d975c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "658d8bc8496f459dee9474b9a8110f8ad1d6143affa33e736dbca6e788ddd5e2"
    sha256 cellar: :any,                 arm64_linux:       "e4708393a93c3029a76349e1faf41b84babea4c38f75b749f07d3f681c540822"
    sha256 cellar: :any,                 x86_64_linux:      "55fb31ec91dc39c8a39a3e71aea7ba1a7c5f6e097a13ed2bb47a5840173edcb0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
