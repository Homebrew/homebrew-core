class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.17.3.tgz"
  sha256 "65263e19599dd185308124b165d3eb1037f7ddc538982c781fe30cba2dc2eb0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccf00eff4193316400a524ee5dd3a5bbb4a5204ef110b94053fbb4272f63f6e3"
    sha256 cellar: :any,                 arm64_sequoia: "a0a3cabac4d0bb45e43cf1a7f23ca765ea58aab9a98baebbec3c1493ca26f470"
    sha256 cellar: :any,                 arm64_sonoma:  "a0a3cabac4d0bb45e43cf1a7f23ca765ea58aab9a98baebbec3c1493ca26f470"
    sha256 cellar: :any,                 sonoma:        "c7b1c5240e96a22c6fc36cab4dca7d09450e45a366d80dfe5d628dae55bdcfb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b22fe3f6fe0ab2b2405ee1ba5272c20e53bb76dfcf5c9edc9b6a48b06614ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a0065f1c554284bde7f549594e07e5acf962cbb7d171ed46fa89825353a9267"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
