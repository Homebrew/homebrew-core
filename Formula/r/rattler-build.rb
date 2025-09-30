class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "56a0c8307893b347eefc24612bb8a81f8cc2ef274aa336608b4bc373346f2584"
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
    sha256 cellar: :any,                 arm64_tahoe:   "d6beb55f2072e27b4fd20a2f1ebdfd7bba41a89320e1493c7e5d2c6d5bc30422"
    sha256 cellar: :any,                 arm64_sequoia: "3fd58ee4881ad30196e81ae4f364c5d510ff0930ccc2a0168b57e75d9f249a8d"
    sha256 cellar: :any,                 arm64_sonoma:  "0f7cab519570de4588c978775b7a22e586612be65a69c3a77164c012aba80940"
    sha256 cellar: :any,                 arm64_ventura: "8bda11d8d5a82dbaa176bd0b1638eb0892e8ad54dfe0ceff289d19d88dd3fe04"
    sha256 cellar: :any,                 sonoma:        "3e703127e25b2af822082e0ca5a9343a34fa80aed76e9eac04d95a5a653cdea3"
    sha256 cellar: :any,                 ventura:       "068b2fdb27a633c8366054323472479a4a1dec7eb24ed47ae1a604eb128ebc98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd7d774bc5051ed7a02af064a7d5b78a219aecf5f2226f2b70aec9c2e55e447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ea103e1d07946a06e258854204df7c72c79ed41cb61d62ca75280f428b9d76"
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

    assert_match version.to_s, shell_output("#{bin}/rattler-build --version")
  end
end
