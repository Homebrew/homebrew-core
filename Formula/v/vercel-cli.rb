class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.21.1.tgz"
  sha256 "f6d3a2b84b480b1315ae6a27ad9768c99db4fea87e9a6290b0d08ff1d9115ba3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67e01398ea6a426b7e8d094f4b0a957c2853f824273054fc9fd12bf42b53c1b1"
    sha256 cellar: :any,                 arm64_sequoia: "dcfb42d662d62e344e1a59ad27e95cbd2d99e4cbeaa5cd0ba2be9d816cd00fd2"
    sha256 cellar: :any,                 arm64_sonoma:  "dcfb42d662d62e344e1a59ad27e95cbd2d99e4cbeaa5cd0ba2be9d816cd00fd2"
    sha256 cellar: :any,                 sonoma:        "b02473e2dc4cfd36ee1ccc18800ff8aaa8c7168122a038e56a477789926db8b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1cb32cc874bb1ba4739aeabc2f146bf49779d6c1afeddff46e73c7fec7b58df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e700c1c126bdc5184fd01d5b1334c4f8ea1ca2bb92fb7e2d291014cbcafc0eb"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

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
