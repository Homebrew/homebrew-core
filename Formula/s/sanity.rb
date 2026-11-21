class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.32.1.tgz"
  sha256 "27c1697419cc80d92c3beb7f84f582b44d6bdc8193de40c25538c69559baa83f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c2c207c948211227ac944c3c2faa48151e3abb504f543a7370832e01e602120"
    sha256 cellar: :any, arm64_tahoe:       "1c2c207c948211227ac944c3c2faa48151e3abb504f543a7370832e01e602120"
    sha256 cellar: :any, arm64_sequoia:     "1c2c207c948211227ac944c3c2faa48151e3abb504f543a7370832e01e602120"
    sha256 cellar: :any, arm64_linux:       "7dbc8106071d692061adccd833bb401dac59d7769b657f2bab02b86b97826b95"
    sha256 cellar: :any, x86_64_linux:      "e3073febb81280b27e3ecf0cb0dce4eee19ef17d9e18ef0ce2933971f055da68"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-buffer,bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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
