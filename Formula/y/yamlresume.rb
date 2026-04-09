class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.12.2.tgz"
  sha256 "17e8c6e63671f26af7e70145a5f19af4aafd620433675af7b793e7ec340f92c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fda998acfcec97483c05bdc7b46bcf8fbd82540f4c9bb3c9f66d9bdf086f55c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83dd4927be0117cea4c6c2bff79a777da9b8d78447c74a3e64043890b77522df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83dd4927be0117cea4c6c2bff79a777da9b8d78447c74a3e64043890b77522df"
    sha256 cellar: :any_skip_relocation, sonoma:        "305df97afefc00d822b98fbc40c18af791b7d900e6a52116306ee4a93d1bd365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9b357c8b999ff054652605ce1094626fee1875beb422061752001c54220656e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9b357c8b999ff054652605ce1094626fee1875beb422061752001c54220656e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/yamlresume/node_modules"
    %w[fontlist fontlist2].each do |file|
      deuniversalize_machos node_modules/"font-list/libs/darwin"/file
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
