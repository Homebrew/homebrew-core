class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.10.2.tgz"
  sha256 "93c7bde59f5d6982a7eb0359bd4adb32a90119c70177eefad961d0f53519379e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "136b9d1b904d319e017e0a83916b185c642679f1cfed40a853d24e004fa7baad"
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
