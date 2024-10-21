class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "fa6a148a573abdf94e1a98b8fbbafc5c238c5c138ad044def139ff561da04408"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8108469ed6309e27c09b7d8dd8e087d52d5428bf2171f713016307d1e668f11e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afd70b752c2e1e8ecce432dec89176a8a29209f6e8b9743bb4df10f7cad2112b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "226b2bbe3e33150823e649be0ac116d1a03b135b68b31254f31971f2a501fde5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f84753788e925013f633cf743022ab912b7838126d8f82515fcef78b8cbc4502"
    sha256 cellar: :any_skip_relocation, ventura:       "cd4378729177a132305197f529fb92e3218db5bce38041ece8407011f6d06777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06605a70ae163cc8e5e6e20f7847e8da1fe61c8a4938e248a0de55a925be514"
  end

  depends_on "pkg-config" => :build
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
