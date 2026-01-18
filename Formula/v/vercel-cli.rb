class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.5.tgz"
  sha256 "00fd2f7542615ca5e0b8a7f47ca313d29abeee8fc526a3a09357f71b8edabb55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b425bfa32fce1d1c5925a3771bfb2d63ef9988ba987e52b40fbf4e9eab0dd7ca"
    sha256 cellar: :any,                 arm64_sequoia: "3264402c8916b876272c15a604a96d671584472da4aa96e4e7b67592d667f2b0"
    sha256 cellar: :any,                 arm64_sonoma:  "3264402c8916b876272c15a604a96d671584472da4aa96e4e7b67592d667f2b0"
    sha256 cellar: :any,                 sonoma:        "79b4bc3e21f0c13a8e0d73570f421223061b3b891d343c3e09b9e541da59a16e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec44e56ebdd52210dcd4c035156607595dbc41f212955e6a2c4e6608cd003a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4df80745732b350ec0420d0f3b473f2a33d1a07c93d6fbee94f419b7dc6f89"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
