class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://styledictionary.com"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.5.4.tgz"
  sha256 "2ac264e1061b3fbf680a7bfa0ca32b44fa0e284e3b01a547ec977a3e27b6d827"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d52dc82c6ac58ab8e74c0d1d92dcd3fe41df42997ab6b295dec01923e4add650"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Build an `:all` bottle by removing example files
    examples = libexec/"lib/node_modules/style-dictionary/examples"
    rm %w[
      advanced/create-react-native-app/android/app/proguard-rules.pro
      complete/android/demo/proguard-rules.pro
    ].map { |file| examples/file }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/style-dictionary --version")

    output = shell_output("#{bin}/style-dictionary init basic")
    assert_match "Source style dictionary starter files created!", output
    assert_path_exists testpath/"config.json"

    output = shell_output("#{bin}/style-dictionary build")
    assert_match "✔︎ build/css/_variables.css", output
    assert_path_exists testpath/"build/css/_variables.css"
  end
end
