class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.21.tgz"
  sha256 "0c409182733544e78ed32aeafca1923e13f9ee464b960e15afd3924f2c739c7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453c104f953c9012798763891ea07fe135b02bda72cc1b4566938065a95be35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "453c104f953c9012798763891ea07fe135b02bda72cc1b4566938065a95be35c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "453c104f953c9012798763891ea07fe135b02bda72cc1b4566938065a95be35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "12cbc9d78446354791dfe2c496bf02fde1e02504eb49470d965862d1004eab96"
    sha256 cellar: :any_skip_relocation, ventura:       "12cbc9d78446354791dfe2c496bf02fde1e02504eb49470d965862d1004eab96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9114ffd6920e951db29a4dac754c96cf725a54cc58ff0aa7a00828b03bb8408"
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
