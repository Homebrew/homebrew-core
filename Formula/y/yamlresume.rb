class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.11.1.tgz"
  sha256 "eecf19120041bedfa4027bf3d95e98cc6cd82b8822816907db991286c4e8c490"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3526e6790c2f04d77fe11d51388cc48f0fa802c8746203548368f1838a1fa24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa77e1c051270179890c7a9b623b3308cd8cabcaf1bd3e39a1a9c12a36a416bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa77e1c051270179890c7a9b623b3308cd8cabcaf1bd3e39a1a9c12a36a416bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "69536254f372ffc76d7d67e7491260e734cfda95a1e7e1e4b68fb4786c0e8798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0be2248bf3e1254c6f3fc055bb131c94a6cdc7c96ec365bc6a7360dcdbe117c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0be2248bf3e1254c6f3fc055bb131c94a6cdc7c96ec365bc6a7360dcdbe117c"
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
