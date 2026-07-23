class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.70.1.tar.gz"
  sha256 "b037a68c7e87e36d3268bbd4a4c527f893805a77394eedb48927ac0647d8760c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03693d0961ff62233ccef281f63eac7272f7a73347abe7c181493256c988714a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07e5b1d3a25a35e5437bea8c48b5f08a0798845141e8ef3ea93429cc608743d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f163d937bc4804b04c1635cd6d832a945facb8140add4df7c1c0b6b26e5cd75b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e893f68c088e68dce4e4a4eb0b592bd6439c0dff065ff1176428042945673d5a"
    sha256 cellar: :any,                 arm64_linux:   "082a60a12cb556d40fa79cf42ff2f200da7b36c53eeb49930783e6a176bd45a1"
    sha256 cellar: :any,                 x86_64_linux:  "64a787fac572a357bd92e3356492222f4605a0caed804e345bdbb25fb47c3ccf"
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
