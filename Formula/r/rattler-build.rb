class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.35.9.tar.gz"
  sha256 "9b64c34f08426156d81c472a7d2f4fe15b8658d6c61f8e293b1f0682d18c6bfc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddfe98e9516fe0b1f8599c6fa5d3cf659afeead19118a236154431dd2e06c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d7f614229c7c24504ec0632742ec045f56861118a5cd12a3020a52cf0b870b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f771006a71968046f8b5472bc34fcf06a871787a100e1ca88afe215dc368da23"
    sha256 cellar: :any_skip_relocation, sonoma:        "09475d6b3b8ce83ada5b3b17811b9a70d8d9ab58f6f95f4f1262a19a63d45c08"
    sha256 cellar: :any_skip_relocation, ventura:       "971642e188b58953e9b5c1539b2aceadf593841e6796be287399bfc5327465f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ba06ed094817e0bdfa78467366dac908f320e63e9c7774f19518209839b731"
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
