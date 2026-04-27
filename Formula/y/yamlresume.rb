class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.12.3.tgz"
  sha256 "cabc5a4b1803ef2be2187592f5db8958281ea3f109b2f8b34cac9d26be8eaa0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "179aa559d9ca0ace8e863b9cecf4bf814b9d74b73258ff5ece8b424091678f20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46634dba92489f94d9d9f48c10375915db153d90c2999aeb7d502a514b495406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46634dba92489f94d9d9f48c10375915db153d90c2999aeb7d502a514b495406"
    sha256 cellar: :any_skip_relocation, sonoma:        "764737e0409d3efda699e3c624276bbc036ae84248078a6f6077110dd93c1011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32820c313fbaf01bc313a06476dee01e400bf219f46954212c0ace858a9fc112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32820c313fbaf01bc313a06476dee01e400bf219f46954212c0ace858a9fc112"
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
