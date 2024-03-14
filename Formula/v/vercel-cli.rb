require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.6.0.tgz"
  sha256 "6ab49a0822549e22fd18a7006c2d443b08a6ee9c91ea1a1e0cdb25ca412447e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df29f365cd951429fb82fa6a5e50ce472e0d3017ca35c1c579e1173dcd6cdf2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df29f365cd951429fb82fa6a5e50ce472e0d3017ca35c1c579e1173dcd6cdf2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df29f365cd951429fb82fa6a5e50ce472e0d3017ca35c1c579e1173dcd6cdf2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "afd7a10d96134dba0109257796c68818dd192806990164b4f9b653557e126937"
    sha256 cellar: :any_skip_relocation, ventura:        "afd7a10d96134dba0109257796c68818dd192806990164b4f9b653557e126937"
    sha256 cellar: :any_skip_relocation, monterey:       "afd7a10d96134dba0109257796c68818dd192806990164b4f9b653557e126937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a4a6da9f5dd98af90359602550ba670d1da2cbab114ea7234f94b3fc4a1047"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
