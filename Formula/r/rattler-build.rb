class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "88e94754a24e85794cc226b0deee6a402c9e7cf7ab8502b0cb0f4705150c5ae5"
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
    sha256 cellar: :any,                 arm64_sonoma:   "0630b14ced10798d8a4ca6c9e37ac43cd89ad98599df58c46e02405e94839555"
    sha256 cellar: :any,                 arm64_ventura:  "74f4e71676f312e98d1b05e1dab18f0d0e27c1c834e14c85d66177728891c190"
    sha256 cellar: :any,                 arm64_monterey: "ebe35b73c96bdf6a8b8e841994f810a697b3ab1f14fdfe0a966c1c118afc6cfb"
    sha256 cellar: :any,                 sonoma:         "9e25ddc6cc6245e503decfcb3706b5bb13c0371074f3ba24d489366d58b35ce6"
    sha256 cellar: :any,                 ventura:        "49cec52040de547da4c7649ecba2dd83b91dc0591b809921ee932790fc78f962"
    sha256 cellar: :any,                 monterey:       "910c933586fd35f22f7994671d538d5a62bc9c1c0a9de8913b165818c316a903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c085dd12230d35574fc778d0132b2708a1937db1b753f76c949a6b081ce41623"
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
