class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.8.0.tgz"
  sha256 "aa883d4de0d59a683986ab0540bc33956b4b2e07aa86904985b66f87c85de2b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da9c94b4ee2b7916a0f249f4fb5207fe14577b9a840f34cf2c1fa7fdbc32910a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
