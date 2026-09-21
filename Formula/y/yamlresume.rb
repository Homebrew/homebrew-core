class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.16.0.tgz"
  sha256 "7bf8c9a0beb540e80ba82f7c0208b4f4c542198d3ee03466d7ca1ca4474593de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1c73104fd114375db08ad6d0189cccb0109831d40195ef884ab46bee97b8e28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b6fffb8ab997cbf76c3f04aad92a32fa4a282ab3f106cca23f0cae242d79c4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c59523c37c93f54158734694161d56c4a0b8289b02458f0e4e63b7d827ecde4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "de424f91443f8e2abb08531f3478d42f078908a0fbba6dcb3beb76be980a3b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e34b02294db4bbeaeb1eb5e0743b0797c2f6430df7c59514265caf22e91ca0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e34b02294db4bbeaeb1eb5e0743b0797c2f6430df7c59514265caf22e91ca0fe"
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
