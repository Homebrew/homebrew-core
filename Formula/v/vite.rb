class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.2.tgz"
  sha256 "ab4de1c849b11191bf8847e9abc07912d314e96ccda5d12338974819344e4121"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a51a6fa21dc1b5e1c0cfd3eafbbe7283d5f697bb13fe328fb9d068308152c1c5"
    sha256 cellar: :any,                 arm64_sonoma:  "a51a6fa21dc1b5e1c0cfd3eafbbe7283d5f697bb13fe328fb9d068308152c1c5"
    sha256 cellar: :any,                 arm64_ventura: "a51a6fa21dc1b5e1c0cfd3eafbbe7283d5f697bb13fe328fb9d068308152c1c5"
    sha256 cellar: :any,                 sonoma:        "07241f8eda06f7ef18cbf9e0e21c09cd0ee532f90798b9fa3d814e8161197e8d"
    sha256 cellar: :any,                 ventura:       "07241f8eda06f7ef18cbf9e0e21c09cd0ee532f90798b9fa3d814e8161197e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf8adef1941b4ee1000789f458555f7e7a4fa9e2463274d9c7377fc292dfe31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54fbf6df42b89faac77078088977e503070e780afa0b8ec42c6d32b02d53ab58"
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
