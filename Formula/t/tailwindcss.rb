require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "555562f66e6d95dcb7feca807988fbb9735fc6fb61739fbc9d55b1cf7299db36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0df20a4a0454f8e43964f54329f6bb44a821a4bd16c6e72620377d6569c5eeb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c102407f292cd9aca1c7852a8b0f476fd0fc2d3e77583eeda50101d57b3a8a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c102407f292cd9aca1c7852a8b0f476fd0fc2d3e77583eeda50101d57b3a8a48"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad143314527cf77f813fd35c66f8acdeb2b6de3a7a48f358b7ef3886ae75819"
    sha256 cellar: :any_skip_relocation, ventura:        "899203724357315d0df894854ff5fa5a5fd28b70a44ec193e0a3b66f63c7e24e"
    sha256 cellar: :any_skip_relocation, monterey:       "899203724357315d0df894854ff5fa5a5fd28b70a44ec193e0a3b66f63c7e24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6331b437940b40523852c335ea67475d3fb11f4fa3589b44b7c524b1a5ccd4aa"
  end

  depends_on "node" => :build

  def install
    node = Formula["node"].opt_bin/"node"
    system node, "./scripts/swap-engines.js"

    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
      os = OS.mac? ? "macos" : "linux"
      cpu = Hardware::CPU.arm? ? "arm64" : "x64"
      bin.install "dist/tailwindcss-#{os}-#{cpu}" => "tailwindcss"
    end
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_predicate testpath/"output.css", :exist?
  end
end
