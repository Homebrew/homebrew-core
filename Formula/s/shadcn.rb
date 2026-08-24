class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.19.0.tgz"
  sha256 "d9ce68f1fc19513daf086bc8b78586819199c4213e208745756cffcada1e45a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "621892e331b8b3da6865c2f8e860c85e9ce1edce5226af21adef68a40c0fdfab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621892e331b8b3da6865c2f8e860c85e9ce1edce5226af21adef68a40c0fdfab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "621892e331b8b3da6865c2f8e860c85e9ce1edce5226af21adef68a40c0fdfab"
    sha256 cellar: :any_skip_relocation, sonoma:        "651e2fa234c5926a9d2ba2e22ed07c2ec87fed32c46234531cc1290dee5fbdc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461db52c57c37975f72939a2e5f91121d5864d70a58fc77078b303389a06649b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461db52c57c37975f72939a2e5f91121d5864d70a58fc77078b303389a06649b"
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
