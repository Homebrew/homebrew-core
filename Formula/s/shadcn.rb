class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.11.0.tgz"
  sha256 "f4306108b833729585883a6ed5c39114ae508e3b1cd90b38130a7000ea798c10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c28eda68740fa4143aa824146599b0717b3b0d45c35d887a5ef02d5e8598e46"
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
