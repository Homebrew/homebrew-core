class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.14.3.tgz"
  sha256 "a919a5e1e9daaaae511f62f3a0079cd1ca74a5ae5b6806393f2d523cf564e3dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45aba94dd84cc32193d3ef10d858ac1cd6f0c7d2eaef9ecb17df2c43e867cb0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75540581600f4b66b154ff604f7f917dd903681e758a90253b1d556e1205fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a4ddebc99f653f1e1742ef8a5c973600624fb0c5d71024b39e07c88805cc60"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4122228d888c10a75903a5a6fc5221cb35f5e7074bfefab6ca11322af40cc32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d099fbd2eec45568964d999ba30197db93907c1eacf61fb2a04571be9a2e53c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d099fbd2eec45568964d999ba30197db93907c1eacf61fb2a04571be9a2e53c1"
  end

  depends_on "node"

  on_linux do
    depends_on "fontconfig" # for font-list to run fc-list
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    # Replace prebuilt binary by compiling based on upstream build script:
    # https://github.com/oldj/node-font-list/blob/master/scripts/build-darwin.sh
    cd libexec/"lib/node_modules/yamlresume/node_modules/font-list/libs/darwin" do
      rm("fontlist")
      system ENV.cc, "fontlist.m", "-framework", "AppKit", "-framework", "Foundation", "-o", "fontlist"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
