class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "a66c2ddddda9ad57240f5b01b1a3ee71b762400ea3c1b2ec462ee103a130d5be"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21c38aaffbde2f423975d27b13e9c1f7c3f4ce7d955f45898b44fe43bc19bcf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38ba1f6e7a5afad2e3b5e22e1d79d89c53fd61093514a48a032a0a412d03e9cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0182f927c6ccb7e3628674924ae57dd7944b768fbdb812df65d1a8e898d88e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "e31a00d9b343729fcdf0c6bd6106111dfcc5c9e804ea354d0cc3a10b4c887f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e0a5c85f9530186da01f6ed824926ba6469a2f29d3e96a2c95b6506343047d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cde57a3368b05eaade33121cfe9cdb505f5ef33f5de757b2188cf8e02206a61"
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
    system "cargo", "install", "--features", "tui", *std_cargo_args

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
