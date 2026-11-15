class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.18.0.tgz"
  sha256 "8a4813499151a3c31cfd0d2332b257d5e9ffd5ab102414353ac377aa2bcb03aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00e33bb8777ed7e1c7406cfa2266dbff13e627a64c8663dfc08058fd336d3d76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b042bc2c476ce3b179ac5fb420249554d8d4299e47b7720f31d87bc7048316fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2b41a0e9af8b29d019827a56c3676bb73a383a0b25f4ecf8a9339f98ce79c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f14ff0d62dd9cbc0f3f7fff8308c32011b61c4d034b82e2acea48518ab84b449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f14ff0d62dd9cbc0f3f7fff8308c32011b61c4d034b82e2acea48518ab84b449"
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
