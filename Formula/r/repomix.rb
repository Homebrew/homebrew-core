class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.24.tgz"
  sha256 "9d3bb88ecbf25d8d0e10845b9200d9c72affffce8f0f4ade9680e982779f09c3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bdbdab173d31247855676e93c7b6fc656d9dcca2aad7068f92a6a23e0123955"
    sha256 cellar: :any,                 arm64_sonoma:  "2bdbdab173d31247855676e93c7b6fc656d9dcca2aad7068f92a6a23e0123955"
    sha256 cellar: :any,                 arm64_ventura: "2bdbdab173d31247855676e93c7b6fc656d9dcca2aad7068f92a6a23e0123955"
    sha256 cellar: :any,                 sonoma:        "38681f9af28d4cb03f764cdef50408fba4f54f5352d0e9a9dd97f37a261f8d09"
    sha256 cellar: :any,                 ventura:       "38681f9af28d4cb03f764cdef50408fba4f54f5352d0e9a9dd97f37a261f8d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d088a1d3a9a6f8cd739d3a2a4dab76059caf2f658c91b819cb6c455e3b5899a1"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
