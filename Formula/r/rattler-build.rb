class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "e4796afaeabb93094dfb990c9718ddf420f96a8c468845afcbb3dd48bba1dbc8"
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
    manifest_sha256 "b5f0cc84645861210cad5318b39dcf262840acb0778660660677f51b3d883fbe"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5351dcb3c00acacf70fade0d5196c5af597af0415e535568ee853559db6ebb78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b98d399fb772e0bc0cbb5101e43603cb487eafafdde7e8670b1a43fb7647766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3270dbe518ab06c28a09e151bc93f728635bae36b442b7b9c21f7b0e25958e9"
    sha256 cellar: :any,                 arm64_linux:       "334f32f525ba4061f2d5962aa720a6ac6c56f488606fb8b490a80cb5655635a2"
    sha256 cellar: :any,                 x86_64_linux:      "c6893f37013d4d14bee0563eee8bcce32d9edb7199b6bed06296d9df29de6efb"
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
