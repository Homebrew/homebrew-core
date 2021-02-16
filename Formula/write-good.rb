require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.8.tgz"
  sha256 "f54db3db8db0076fd1c05411c7f3923f055176632c51dc4046ab216e51130221"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a735c28a8d8a652e6f691de1ab62f724ee439338b4c217b02216331d9d8f818a"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf662c7fdc80b156e86fb965fa7a168c8b6ba2ca9f1a1c781ea304bfa56eb2c0"
    sha256 cellar: :any_skip_relocation, catalina:      "74167adfc2d6d669166dac2c7963f02fa5cf8bbc48a30d3a087bd2c38ecad4a4"
    sha256 cellar: :any_skip_relocation, mojave:        "c2fca0ad0044ec1042a9c1f424c16cccafe8f84ecda3427b8e444262253aa895"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "So the cat was stolen."
    assert_match "passive voice", shell_output("#{bin}/write-good test.txt", 2)
  end
end
