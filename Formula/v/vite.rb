class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.3.2.tgz"
  sha256 "f88f798006657e0cee4f058319f5a8ddcd7194ec1d1856862dd97cb344f19f51"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fca57d8dcd8b354193029a121cb41d0d386cc8258043b37f7e300ad06ccaebd4"
    sha256 cellar: :any,                 arm64_sonoma:  "fca57d8dcd8b354193029a121cb41d0d386cc8258043b37f7e300ad06ccaebd4"
    sha256 cellar: :any,                 arm64_ventura: "fca57d8dcd8b354193029a121cb41d0d386cc8258043b37f7e300ad06ccaebd4"
    sha256 cellar: :any,                 sonoma:        "1015f6c15d21398b151c630fff32d8e28732213b50caa586a8a87d6172491472"
    sha256 cellar: :any,                 ventura:       "1015f6c15d21398b151c630fff32d8e28732213b50caa586a8a87d6172491472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147f32df08591461b8193beca47526d46e616546ee1306c0a24a483f08b926f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d46805eeec83cc477eefefec09c959ee0c298f16dbab4f75db5a9f72b9d0852"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
