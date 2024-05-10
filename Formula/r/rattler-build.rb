class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d2dd608e0eab32756a7d30320f713e7cb497ef4b1374ce5fcf9bf8b97234c6f3"
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
    sha256 cellar: :any,                 arm64_sonoma:   "9aaf6382f0a108105ecbb6b7c40c7b97b77c932b35e9f1c22f51b5c821b5b930"
    sha256 cellar: :any,                 arm64_ventura:  "bf377f0619005937e2772d8828df979512b3ce3a91f08a05cf7b8bcc218e7155"
    sha256 cellar: :any,                 arm64_monterey: "0cba9ed9f79c9a970a684c3a8be297898d161d1116bbce4a03218fed39c002d0"
    sha256 cellar: :any,                 sonoma:         "2aa41e20e3295bf203e390be668458ab86325214e1a289aceee0ef67dc7962de"
    sha256 cellar: :any,                 ventura:        "0c5ce5a3293e742102835dc19539bb3f3c3e210deb8c72b1735c6e0435d81cb8"
    sha256 cellar: :any,                 monterey:       "2499831aea122be92eea28486d169b8d1b3185cd49c090e0f0f93e49a58370db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da826d333bc41a2240e16fb097df83b6a0990176a5ce29f479eaf8589ba673a3"
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
