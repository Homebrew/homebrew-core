class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "0670a1ff57f7dfebb176395dd4d329f0bccf930d8fc552c6e52bd7ce72932563"
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
    sha256 cellar: :any,                 arm64_sonoma:   "6c5adae253c5d1c4dd4276b19de0befa775bce5a5c15e1684a82c53d326b19f5"
    sha256 cellar: :any,                 arm64_ventura:  "810813efb4f0a62143baf427e8ece6bb452024bde3b45895558f0816e841b3cf"
    sha256 cellar: :any,                 arm64_monterey: "b59aae2dc53b22b59f1bce668d34cd63404f4129ea648b2e19780c394115c90a"
    sha256 cellar: :any,                 sonoma:         "5515a6eea5eb3e28455731833a28bbf61f9a3249fc962e44ba68bda72d8fefba"
    sha256 cellar: :any,                 ventura:        "93bec871ace6c225dd56ef35ab07ac68c3bff20dcd2fa740f334c35b0b1067ae"
    sha256 cellar: :any,                 monterey:       "df22d0b58b842b9b5dd513b82b464468343505fed8682afe92630ae3e045727e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7498ae2ce56e2f14e01da5c543966605edf7e23c27ad9ac925ad004a1475f3cb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe"/"recipe.yaml").write <<~EOS
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
    EOS
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_predicate testpath/"output/noarch/test-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin/"rattler-build --version")
  end
end
