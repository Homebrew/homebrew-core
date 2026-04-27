class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.5.0.tgz"
  sha256 "0cca4ce9bc1565f5696adaf3262c5de8c73e9d4694cfa21a12bca84ca40470f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3f5c4e80ba3a124193046c7a61ae8c175a08f56a080dfceaf5315e37e08a468"
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
