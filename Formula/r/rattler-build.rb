class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "f60739e4815873ff6fa18c54256ecf46af8743136d64b659a2b6eea15fe8bcd6"
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
    sha256 cellar: :any,                 arm64_sonoma:   "23119c0bfe78f0773c83e8a4812d992f9ee3ca2200a212b463c1c7edb6b2034a"
    sha256 cellar: :any,                 arm64_ventura:  "a8b867df79529c0a90f9e2acc174ced51edbdb5c560744d17acc2253094abc31"
    sha256 cellar: :any,                 arm64_monterey: "5a547da2b7c78a95aa5e8edf80ab68a575f9d0bc3fba53ba678fc6d5b1056bb9"
    sha256 cellar: :any,                 sonoma:         "70883c0d944cd46d29775c9a2fe10adfd12f231cde704eafdfd9eb7d4da2bcc9"
    sha256 cellar: :any,                 ventura:        "e8a480fe3fba55edc9e5e03121844b92b327462ce8ba305ec142f3397e6eb6b8"
    sha256 cellar: :any,                 monterey:       "c96996898dee8b57712d04f2ea8c202aa8d18ce675422cdc44967817ea6b0556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d403c0c46efcc8031551dc16a0dcef71aa94add6baad0d27a59ff20dcf2ad8"
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
