class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "9099ba0d9f88171555417b7ab74a8570d7c5f894f93e3c1fed16399965bbbef4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee587d612d4a924813bc69fe23f5177ee6ad6d475ef864db5d6fcbe57377176e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "385cebd1459ac2d0b5c4e084d090904c5c5c3f6ba49a95d1d794806b2393d89e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89856843621314c308f7ef2f547a4ccf302ac28d591bef635f42690b4dce5f63"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdff9873fbe861db79034703b600054430c1fa50f7414dddea86cfef6e3526ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4dbd2e2072400ad6df41d583f4bd90e39c4f35c92597997dbcbbbb0eee8b153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d325a05fe4b1c3b43f8e9077e590297051bfff8f0f315356bcf5a2bf62e5af"
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
