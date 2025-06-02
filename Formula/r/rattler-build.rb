class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "9627cb861606cfafddbfbffdc4bd623fd342fe5f60423e905a55b3e45d767b90"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1184d0eed1aad636dff858b160ec490fd05e9d12a7906e55960f040907b4e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105fc76f786755b470a867b72ed20835c9084b24c9bf7df5a108de0e9a430893"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feda3dfe8d966da88288f4b25aede82aeedff93fccec60477a6450c7eaf4925b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97ef831e035576a36d20166b203185eddbe27d90d2898b5681539b07299267c"
    sha256 cellar: :any_skip_relocation, ventura:       "e3746e97bcaf588214763009dac86e88be5fc037af57106ac062ce063a638f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1b92b45a375f86df178f9038642bab4fc3f3b072fff7a5e341a7e78bb6e066a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7f664d698de7aa26b4993e71b28bb03f267200ed270b5a30ab30e49db3171d"
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
