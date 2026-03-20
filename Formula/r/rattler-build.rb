class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "592e4ae8fc3a89b557588670d6e9f92b3c975f03e0d79390c526ba116eabed2a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45e3ae9a717c10b20203145ed550d0c20b2a442e21e5a34a833bcf6d7784620f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c42e900d6f1a599493f5bb2e1cd3e45ec505b7f0d116794d123a13426f4c885f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de59dafa2017ee914bee9dc4f9298a5734ebe7266b970d33c6893e0c3451b161"
    sha256 cellar: :any_skip_relocation, sonoma:        "beda36b76d4a94547be7be372707a537af8c2cb5bad1526bec07e85ba7febba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ed6cef18a0c6bd0750b6cfca7bcd0dd6b85e3f6d99c58f7ceabff3cf14fc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923fbed46490e25187214147bca232ecbb9c972c7c31be56fdb1e13cac5d30b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
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
