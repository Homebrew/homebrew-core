class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.82.tgz"
  sha256 "5c576b77c6ede6decd35f172e761af695c4d2f7fe1c9bdb816631e1d8c0e053c"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05348a27c4fdacb0aafa56640f7854f64a9372a3c22869a2ce7088b7b293738f"
    sha256 cellar: :any,                 arm64_sequoia: "5f1d1f6cd16185f72770189893f0cc637e7ccdeccfbe2938beed48516f0657b3"
    sha256 cellar: :any,                 arm64_sonoma:  "5f1d1f6cd16185f72770189893f0cc637e7ccdeccfbe2938beed48516f0657b3"
    sha256 cellar: :any,                 sonoma:        "9602931143ae5ebd737686fcbc977e2aa2079174190a9182cb44a1ee343df995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d08476f02505d35494c06039bc9891ce10c97908f4a5f151ca08acdca430a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a3d519a492ab878455a4ecf7c3f7fb86d31fc278147bdf6e691c813d7c9f69"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/yuque-dl/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
