class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.2.0.tgz"
  sha256 "7303f9759b23864a1a519d966dbf47fd4808e7b5ff66e601ab532fdc674c73f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c1fa137fee02b55e557f00054cbe411e877b6253cb580db0ae6ad49ecdf9307"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
