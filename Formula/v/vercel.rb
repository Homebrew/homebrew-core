class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.23.2.tgz"
  sha256 "050213ead68f8ca8ff643e134407d52850a452098b3d95ac140e05141bcdabd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b992139e435502ec2d96fc3584a6e6309ed01df92b2cc670cb7177918b5c83cb"
    sha256 cellar: :any,                 arm64_tahoe:       "b992139e435502ec2d96fc3584a6e6309ed01df92b2cc670cb7177918b5c83cb"
    sha256 cellar: :any,                 arm64_sequoia:     "b992139e435502ec2d96fc3584a6e6309ed01df92b2cc670cb7177918b5c83cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7516bfa3bb763870d2702d9d7f3d0e67e7a954a4fe61865062479f13e63f593b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ed428c1b34a3ce7b324421ef8c57f299070986fa250b86bc18f62c586a81fd80"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
