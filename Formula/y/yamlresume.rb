class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.18.1.tgz"
  sha256 "f5be97cd293c29d0f8786427c2072c1e3d9b0cf8913533061c094fe8c785da27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d7eb260904f85e7e6ef8998bcbfe51c7d409309d63246f0eb2682fce1374c4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b5b54fbd77f473a8d10b2c3e8c4945c7110450fe2b85253728cff9808991991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "666037e5c2913645df76d78439f917300f4f1935c9958882f8e47c87cf3b94da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9803d7a19becad09f3f16e50cdd05b4fb6e0ed18a317ec03fb5cf6f531991c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d9803d7a19becad09f3f16e50cdd05b4fb6e0ed18a317ec03fb5cf6f531991c9"
  end

  depends_on "node"

  on_linux do
    depends_on "fontconfig" # for font-list to run fc-list
  end

  allow_network_access! :build

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
