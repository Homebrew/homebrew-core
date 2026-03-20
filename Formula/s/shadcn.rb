class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.1.0.tgz"
  sha256 "516f5ce69cce29cb2dc8cedcf5d7b1c0de9476d752a6e4ca9240ad6aa1600f42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02d50a83394114bd628955c6d312053c13b437371b2f68131e462294193cc0ad"
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
