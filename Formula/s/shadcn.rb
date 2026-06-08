class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.10.0.tgz"
  sha256 "f84bda4514eedd13a41b2920c7a6b6ec38529d7b3cf1ecbaab5e978d459e66c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb9539a51b32ef724222b6567e63cba560dd21af6247affab7241468ced2b9ad"
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
