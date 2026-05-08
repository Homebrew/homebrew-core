class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.7.0.tgz"
  sha256 "5d2155e7015f74c55552cbcfde798ab336d693d05690461bfa83db4aea09b203"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c347ec0ddf7c0fd5b700f87034b50ebae1d62a60a87c0be78466ebfeef866631"
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
