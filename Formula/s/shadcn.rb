class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.3.1.tgz"
  sha256 "a3703ca2e76b81a46dd12f42d5e99127c4e4b40126e183e7129d5e1f8311ddc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c878c3e74a1001d1403f5320c2d8b50ece7e27dec5a3d67e51da4f5d094c55ab"
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
