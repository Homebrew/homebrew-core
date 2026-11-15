class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://github.com/microsoft/TypeScript/archive/refs/tags/v7.0.2.tar.gz"
  sha256 "8472f284b1465f5c4826a64c88853eccba667446f31a435ed1d0b28d373dbc0b"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "470f605fe17553307fd39545f9966ad8be2a8e34f5f05b0e0262bb9e5a159713"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "470f605fe17553307fd39545f9966ad8be2a8e34f5f05b0e0262bb9e5a159713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "470f605fe17553307fd39545f9966ad8be2a8e34f5f05b0e0262bb9e5a159713"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f7a78a6bad897ac04acb2cf520f5743b8c501dae50898a9075f256844238ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8b46d60170f22d1a52b565f01509f594f450cd71b94342250e9f930e96fa8da6"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "tsc"
    cd "tsc" do
      system "npm", "ci", "--ignore-scripts"
      # the build's codegen resolves dprint plugins from the npm registry at
      # runtime; run it once here to populate dprint's plugin cache
      system "npm", "run", "generate", "--workspace=@typescript/native-preview"
    end
  end

  def install
    cd "tsc" do
      # Upstream stamps the built package.json with the current commit, which
      # is unavailable when building from a release tarball.
      inreplace "Herebyfile.mjs" do |s|
        s.gsub!(/^[ \t]*const \{ stdout: gitHead \} = await \$pipe`git rev-parse HEAD`;\R/, "")
        s.gsub!(/^[ \t]*inputPackageJson\.gitHead = gitHead;\R/, "")
      end

      # Without `--forRelease` upstream packs the host platform package only.
      system "./node_modules/.bin/hereby", "native-preview:pack-packages"
    end

    cd "tsc/built/npm/typescript" do
      # The `typescript` package only lists the platform package as an optional
      # dependency, so install the locally built one instead of the registry's.
      platform_package = Pathname.glob("../typescript-*.tgz").fetch(0)
      system "npm", "install", *std_npm_args, "--omit=optional", platform_package
    end

    # Prefer the native executable over the Node launcher that wraps it.
    bin.install_symlink libexec.glob("lib/node_modules/@typescript/typescript-*/lib/tsc")
  end

  test do
    (testpath/"test.ts").write <<~TYPESCRIPT
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    TYPESCRIPT

    system bin/"tsc", "test.ts"
    assert_path_exists testpath/"test.js", "test.js was not generated"
    assert_match "document.body.innerHTML = test.greet();", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/tsc --version")
  end
end
