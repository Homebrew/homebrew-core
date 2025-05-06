class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.3.4.tgz"
  sha256 "5c244f33fbbe0c73f6c8e6378bb9dd5c568bf334fab312c6ab0864f6a8687d50"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01f38582038053fdb36606ea64ee6f52d58ed1eb8638051f991f8694492ec954"
    sha256 cellar: :any,                 arm64_sonoma:  "01f38582038053fdb36606ea64ee6f52d58ed1eb8638051f991f8694492ec954"
    sha256 cellar: :any,                 arm64_ventura: "01f38582038053fdb36606ea64ee6f52d58ed1eb8638051f991f8694492ec954"
    sha256 cellar: :any,                 sonoma:        "ae941817676c7912f4523e295e27d3a583094df778c0308ad6378600c8594bf1"
    sha256 cellar: :any,                 ventura:       "ae941817676c7912f4523e295e27d3a583094df778c0308ad6378600c8594bf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c6959b9dcd9042e5fb8b5eeeb77c97d533b04f2db8682a6eba0d881e5562d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135296a8fd8d6f1eed8b26086e3957fc2c8c2583e8ff0ccd36ff787ed89a7843"
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
