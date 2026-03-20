class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.83.tgz"
  sha256 "998a3339716d7cee76591d5a208ca22ea119e32384ac1dbc70a9b6f98413cc3b"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0880a8d376bcacb4d1855583b489cbb657114a5092a6e18c2b1f4678d7ebfcd2"
    sha256 cellar: :any,                 arm64_sequoia: "97a9903bf2a8885e75388846eedf37eb033b6faa4f13e5a4dd687c16487d5460"
    sha256 cellar: :any,                 arm64_sonoma:  "97a9903bf2a8885e75388846eedf37eb033b6faa4f13e5a4dd687c16487d5460"
    sha256 cellar: :any,                 sonoma:        "c42cc4e4a72e86cb9e5d48153c91f7155a5553160ddd9c04063c2818a9f0ca76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0848bc6e84557947d7e7e674479b8e61b8e12bfc455f8e227d1da42d03ef831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4dc3351c18aa9dc2a86132a922900dc8590b55ebd7399c5fd30f6937e3a304"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/yuque-dl/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
