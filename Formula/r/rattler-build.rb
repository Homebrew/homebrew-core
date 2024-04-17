class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "4b5ab12d861292c5df19448b0833fcb8a4b57331cf007cd0441eace3d2295367"
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
    sha256 cellar: :any,                 arm64_sonoma:   "b9bd7f21a4e1a025cae654c5f6cbcb034506511ecf2d97c506bfe52517d17146"
    sha256 cellar: :any,                 arm64_ventura:  "1107f0e149425c297c91ad7904570923fdd082820ad1f4ffcbbd453ce6522ecf"
    sha256 cellar: :any,                 arm64_monterey: "58944b3561ce3626c2d4f86f0eef1125024003474cc7aae5881fa477d125e02d"
    sha256 cellar: :any,                 sonoma:         "5b3109015d1614c3e3bc7d4e6708d136a377c1ae83952b658d23ec160a78063f"
    sha256 cellar: :any,                 ventura:        "49a263d16430b01b341c74123d52fedf2646194b2cab0f0c96f86ff4345b4615"
    sha256 cellar: :any,                 monterey:       "eb1feab85cd2d859ffd0fde7969ebce496fa21f252ea8c83df5afb4bff424f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e7bcd40b4fd1a369d9287dea313a4525247aef3708c03c85b65c5e3fff31a5d"
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
