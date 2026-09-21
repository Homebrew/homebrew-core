class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.0.tgz"
  sha256 "8341c0e40cf1700c68998ce5e7b1c715b9f89d700abf6c41f5d8af067a270a72"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "744543ba6c5bdac39b029ba7a79b943226404677e3ca0b95531e042d042f9e64"
    sha256 cellar: :any,                 arm64_tahoe:       "744543ba6c5bdac39b029ba7a79b943226404677e3ca0b95531e042d042f9e64"
    sha256 cellar: :any,                 arm64_sequoia:     "744543ba6c5bdac39b029ba7a79b943226404677e3ca0b95531e042d042f9e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb76a19f38b6e11db6db5b8249fa5041fe7eff68b29c2a48023d3bc6a76ffe84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8461719ddd2f4eb77382456abf572f2c8fefe9fcfb8018f49e3015f225cca952"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
