class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "aa667046814b7c17a245604af685dd4127cfbb04b75c73dbd6915a75dad435c0"
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
    sha256 cellar: :any,                 arm64_sonoma:   "fa6935b2155b9e8ac876ed7ff4e318d9d6f98f3477e64e4acfc7ef0c729dc943"
    sha256 cellar: :any,                 arm64_ventura:  "0bd65e2ac745ad5eed9fcbb88af8959c2e2d621c37cec630c6ffe32204d2fd84"
    sha256 cellar: :any,                 arm64_monterey: "369be64b5b8240ad233a82fb3f385cce31b18575a48794ea04dfc3d540d59933"
    sha256 cellar: :any,                 sonoma:         "88b64ac15cd9b4987bcbe363f59b348fee34456bd3f39ae14795894616ed4aca"
    sha256 cellar: :any,                 ventura:        "e4c3809cdded43bd962609e5b50958bf01317f881ff4a02429803523196a03c3"
    sha256 cellar: :any,                 monterey:       "28bc41072247710e002cd6e4b3ef84a73e70c9abd1a4785a77eef1b93168da75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab85e930be1a27052fec0f5737863fa227726f0263e55f0d4054b3987cc94d74"
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
