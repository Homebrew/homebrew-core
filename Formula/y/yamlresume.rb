class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.8.1.tgz"
  sha256 "021fbab2315534aa0b6c521f353f6550bd6e9f9db23ce9574169e78d6b64ee4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e48e56aafd829e51b005d668ad34339440bd9eb783b0fdc7a502372e49e2e3e"
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
