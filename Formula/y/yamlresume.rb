class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.10.1.tgz"
  sha256 "e1027e3b61e19853674f9db52eb8acdc94be28ea93d8cb0afe9924d8e39604d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9da1e19e1ab8f6087c97986f5fdd4e7656cb20ea3675868e01e2d1930e7dcfab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
