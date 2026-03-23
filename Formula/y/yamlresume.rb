class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.12.0.tgz"
  sha256 "a0a03a6bfef866868752658042c5b771320119f1589383a729e3547227f52e29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0e6731a229a73057a50ec50fa7b364d696cd7989254cb725b887603c03075a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67adebe260ef9a7f7ec9f2df0fc6fb3a553654c1b716dd795f5207b8a56a4518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67adebe260ef9a7f7ec9f2df0fc6fb3a553654c1b716dd795f5207b8a56a4518"
    sha256 cellar: :any_skip_relocation, sonoma:        "5652aea88fcb27c55268d720abf14b781f99710c873faf5b867bcfbc3bb4fda1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e01f763b2fd20d36c6c9e5996f38beb15613f23dee674a66d89b691f23259e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e01f763b2fd20d36c6c9e5996f38beb15613f23dee674a66d89b691f23259e5"
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
