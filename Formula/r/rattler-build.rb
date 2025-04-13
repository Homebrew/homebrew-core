class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "6625a0175d62d0b3cc957e683e9de4258a413db6e6a7a613be86cc15a495c2cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b83d32bf8a6627fa96a41db1d19defd2a1d34c0b93f35d7d46b19d213159a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb1d4943e196b9a6af188db75eb588401cd5883e383eaaaa1a69fbede71a100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17399a0441779c1a77aa964550364cb8111679e52acfc4580b1a8b15d635045d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b32d7196b523ea4eedc1fb7a96d07828c176a59e033cbc25c090c86b2631e70"
    sha256 cellar: :any_skip_relocation, ventura:       "19759efb47db5fbf211c09c80a72051e7a30f567fe6075110e3ac14cb0a2ceb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d47f7d521104cefcbe62a868e03ec0ce8eef5d7efe6decf2c61c1f2fb33dd0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699adf86efaaa24f2c21cea9cf9fec055e49da3747c9abff7daf9e45b82a8e5b"
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
