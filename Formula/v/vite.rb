class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.9.tgz"
  sha256 "a00087e615256b0c35e16acaac3d234b4ac742b16593e80031da9bd38d874ba8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40b0d2e0595d6a0fb7cd0eb0d5526883a94ed6e06e812ccd69abc71c3bd84054"
    sha256 cellar: :any,                 arm64_sequoia: "2edd89b6a8c456f3dec079a10e5742390980a54cea9f38a5d92951cd4075f14b"
    sha256 cellar: :any,                 arm64_sonoma:  "2edd89b6a8c456f3dec079a10e5742390980a54cea9f38a5d92951cd4075f14b"
    sha256 cellar: :any,                 sonoma:        "219fa09907860372d4a520ee38c2115ecc7c4503e09785067d7929eaf10bebdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70728ed5a5fae7d47aeff137696855a02508c6c0b16854c537792a45d47f2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb3845096d0f747b8309ef146492c034446ab093164249cd59b10c04612044b"
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
