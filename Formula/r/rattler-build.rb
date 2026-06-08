class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "d4d7f52d588eed34cdb6cdb2caa68125eb0010b6df9291e3acacecca820a9f4b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8eb92755c372386c03c5b4284d7bd1d54178efe1d68da1ee33049115dc5059f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046b00744ac85b1be9d5de73d8b149d081079fcd17376c36d0f5f9a19d5c8b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d7a892881c642d72da86c6b758c714a1811f2f8bc18eae731469925b4d27fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f88e26ce5a27f8839209d42bef6ff8c6f36f00d339f7ccda017b6eb1077da0"
    sha256 cellar: :any,                 arm64_linux:   "4f791a26081d8202d6e4ae5c0bbe4662a78a10bbe6110191f3d22b6868b49b66"
    sha256 cellar: :any,                 x86_64_linux:  "faffc91cf9d822aa387397c16c0b2ac8cfd5b66aefe61a4b12f39c1945e51e72"
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
