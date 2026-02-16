class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.18.0.tgz"
  sha256 "6976f171f9a21157d272be04a7a6b3c93ff862d8389ce51288e5973cabe9c6bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b806fcd8a74e8abdc05e38e9dc1cd5fd638da73cb917c2c27e19f611f91b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b806fcd8a74e8abdc05e38e9dc1cd5fd638da73cb917c2c27e19f611f91b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b806fcd8a74e8abdc05e38e9dc1cd5fd638da73cb917c2c27e19f611f91b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f0f879d85e3635470d4c15bd1bd8c67a5dda68e2b8058ea4c330e06f57217ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b3551a2694dcb527194144f117f4856204f32c64339378e374fe3bf59a9423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ad55e3e085e80c560302c15f1db6835cda527ac2eb1928dc4468fc87eb0f5c"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
