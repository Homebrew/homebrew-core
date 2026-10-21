class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.17.0.tgz"
  sha256 "12cf7610e1de184f6e8e60363c1f7be8d894b5d5c9f345c01f626297ff6754c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "caf988333f205b4c7c66d427b1c92e83e65c3cb8e82b7aa153efc6ead3b99433"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40bce37671bd9a057c28dfa4a798555c2fbabb890a5c9014048c0b6f6d1c3e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bdfafa3d786903ceba9a42b53220b8473d9c4da4a959ff21e12c88d5a568af8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a341115bcf7d02f5460d296f7e27c22d0a4f275a2ce4f3bd5270315ebd1aa3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a341115bcf7d02f5460d296f7e27c22d0a4f275a2ce4f3bd5270315ebd1aa3fd"
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
