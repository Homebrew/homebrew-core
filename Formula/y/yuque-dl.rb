class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.84.tgz"
  sha256 "c7868454ed6ff486ee1ef5261003504dd304174ef4914bf787bc3f70acfcd1f9"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f37af702e8ddbe1ed3cf1dea132d843b898562e1e467c8aa226ba6809ff2d3b"
    sha256 cellar: :any,                 arm64_sequoia: "b7ccced3ec9c2678bbf06a19bafb7f59ddbc1f567792ed90bef84bd1460477ad"
    sha256 cellar: :any,                 arm64_sonoma:  "b7ccced3ec9c2678bbf06a19bafb7f59ddbc1f567792ed90bef84bd1460477ad"
    sha256 cellar: :any,                 sonoma:        "961c0a80da9238c1e32a7896fa68ac25decbb0f250d1a6c759c1f5d6f5693bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3490df9bc7e06c529dc73a42bf5a19583b3b143bea600b6876914f966d7ffe67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a07b2a10ca14a4008880c1cd7e6a7df79c4f2f42d1fec69c10e889eb4cdc07"
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
