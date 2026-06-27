class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.4.0.tgz"
  sha256 "736d36e5c4b50b9917083fc20471343b41260e34618ddc6e77ba4a1ec0332a11"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a06ffa20067f399fb93ad93b16a3859914b5012d62c19d2e8e190e33d3a816dd"
    sha256 cellar: :any, arm64_sequoia: "f25e24a8ec5ab8f96b8663935d0d418f98e9464e6ca0f3ff27b3c7da14441e83"
    sha256 cellar: :any, arm64_sonoma:  "f25e24a8ec5ab8f96b8663935d0d418f98e9464e6ca0f3ff27b3c7da14441e83"
    sha256 cellar: :any, sonoma:        "7ccb4d412832dd5fffcd832cd0a360c7763e3315804751897997548219c993fa"
    sha256 cellar: :any, arm64_linux:   "6f75b67c0aacc2d9e13a290fe290eecc742c797c1be72086a12e2b2f4c54f8b2"
    sha256 cellar: :any, x86_64_linux:  "43e7a02998547a13a2cd01a3945e500d8d2d56d346438003d28a14760e9220ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end
