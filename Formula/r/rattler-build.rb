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
    sha256 cellar: :any,                 arm64_sonoma:   "143b7675d87f8d5e6e0deb6d4e4fd1be539b081a4f16af657d0b6aef31c80593"
    sha256 cellar: :any,                 arm64_ventura:  "3c360fabe1178c8ae5e4955c9f0372bfb0d109a22d3133ffbc624a876c987f22"
    sha256 cellar: :any,                 arm64_monterey: "a29c892aed143bbfb2aaa669ae24abc3f0066146889de12b9b9d8b89027a1b80"
    sha256 cellar: :any,                 sonoma:         "be5f18b66cd0634340cab6afbdbedceafe593e50e8b9c2c7863f3815cedf6f5d"
    sha256 cellar: :any,                 ventura:        "ba8475d3f22a768d20af72097040881bb7b758dc97ce4f062d1b8f390232e3bc"
    sha256 cellar: :any,                 monterey:       "fe0b180771b5b68c6d4b244cf141b57dabec76fefb3a377e645eb0b72cc53285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf166f834a7a888c3bf56c9c2eb7517bd656b091d73df5d0290fa7484b92ba3"
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
