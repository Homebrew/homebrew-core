class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.9.2.tgz"
  sha256 "08356e22d059f8113af908885739d52ce9337c8959dd51122ee12c2d2e37da33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83d7fd007e193201f77005ec7a8b5c405dc06fe96e28706efb44cdc5e2e6d81a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d7fd007e193201f77005ec7a8b5c405dc06fe96e28706efb44cdc5e2e6d81a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d7fd007e193201f77005ec7a8b5c405dc06fe96e28706efb44cdc5e2e6d81a"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d7fd007e193201f77005ec7a8b5c405dc06fe96e28706efb44cdc5e2e6d81a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a44fc7b279a1d04caf67d2d697acd23b3aeddff1af016e6c1f1c942cd8b051bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44fc7b279a1d04caf67d2d697acd23b3aeddff1af016e6c1f1c942cd8b051bb"
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

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
