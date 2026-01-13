class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.3.1.tgz"
  sha256 "ee3fdac563044ce81e83ac2bcaedee891820bc55800ad71f6ead7e12a2c7584d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ffc9dc9018f1fdef2e9b0f4fdba1894862565d2acbf83cd6ca68130fa674f2e"
    sha256 cellar: :any,                 arm64_sequoia: "f5562787bd45ee9375160a019e2994181f151a448ef92b4179587f22e3aa01df"
    sha256 cellar: :any,                 arm64_sonoma:  "f5562787bd45ee9375160a019e2994181f151a448ef92b4179587f22e3aa01df"
    sha256 cellar: :any,                 sonoma:        "249f4d5b8620984ef313bac2c3c73622007a13bf66e5d4554dd68a226db663e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e548df2bab4264876409f48b2af503291eb7c471298d6f466d9a110703383420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "814156432af1319eeba8072b73ace3d1238ca340a507378cabe99707992a5f83"
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
