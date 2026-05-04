class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "46546d11a32d97271ff3e11719c017e7050beaa999b1d4c5dc2ca6ad402e7f02"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3135d2956505efb50f76f58c923b7300afadcb5ffc5fb9c95e496f98b2bfabf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb72e45c66f7373ebf3c452f1fa1c21c5cd92996cb24693d1bc7297c16706108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf35407b7d3e2db8b5ab50a7a60fdcdf36d6db6dea5b8b0c5d4cb7f42fa7c49"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e24ee2f71c20aac5bfe23f968fed61ae16d06a7d34ad224591866592705447e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ffda8340a30b5727b2adc7b992722338267ce90d84f523c32250c4a977bc232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af7181b59b4635efbbd3395b509d79d7d260e799f1ed5a5dec9ddde08bfb2e35"
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
