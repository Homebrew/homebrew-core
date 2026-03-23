class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.11.0.tgz"
  sha256 "42a01afce2a012d6f20073df4098e51eccd4845f152b8e59d7e8b71e0012f833"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "223bd8030feb6e577ffe1a2b357377fd36e98bf5611d5c79165740ffe30a554b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223bd8030feb6e577ffe1a2b357377fd36e98bf5611d5c79165740ffe30a554b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "223bd8030feb6e577ffe1a2b357377fd36e98bf5611d5c79165740ffe30a554b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f87b90646c41728c5742ea49df44b6e69dbfb3de67bcb2476c8c01d10d0f309d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8dc4d350126333e86f5483e7970c5dd0109cb1b66584f5b05ac12feb0db81f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2414e36472a326099fb375fd07ec2990ae5681c3a837781af502fbb27a23666"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
