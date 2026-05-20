class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.2.0.tgz"
  sha256 "7b01369cd82e94999a928473ffd527e0ab02524fd7807acc979d7ddc6b469a13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84e8ac3aa4a4ed263a18ed8e5660d6fca583e2b685b87247239c188dda9733cb"
    sha256 cellar: :any,                 arm64_sequoia: "0300fd85b4fceeb13e512e53aa385dac47be3cafb37b52e6fce2e891fb7848ae"
    sha256 cellar: :any,                 arm64_sonoma:  "0300fd85b4fceeb13e512e53aa385dac47be3cafb37b52e6fce2e891fb7848ae"
    sha256 cellar: :any,                 sonoma:        "ef447b84b065f43de02795d322a262ce991b1dd224832108d1cda121f744c993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a72bbd69531ec949939fa5a972e915ed158bbda2ce957dd3f93dbc75fd5c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e12f847f7ec2cf9ca7324f4ccac0ea89a2cf440bd302219dec3d47761c780ae4"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
