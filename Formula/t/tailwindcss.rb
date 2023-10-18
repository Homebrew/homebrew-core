require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "f63397605839c9a8989924b073962711a759c3d51bec641be487e5fddc1d5a08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dac773db8b95bc5c61698f79b448a73d85d2ed6153571f90f4d84f398a84347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fdb912f3b5e441ef509d688118ad3965a2f92fa4d0601a1b0fd1d15e6cc4e75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fdb912f3b5e441ef509d688118ad3965a2f92fa4d0601a1b0fd1d15e6cc4e75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dac773db8b95bc5c61698f79b448a73d85d2ed6153571f90f4d84f398a84347"
    sha256 cellar: :any_skip_relocation, sonoma:         "8130046aab1d5652bfa3e74733692240410820a86fe60173a132ddaa37e4432e"
    sha256 cellar: :any_skip_relocation, ventura:        "e90486f16f96cb63016e0fc51dd5a05079405c5d78f764912f594a0801bd7841"
    sha256 cellar: :any_skip_relocation, monterey:       "e90486f16f96cb63016e0fc51dd5a05079405c5d78f764912f594a0801bd7841"
    sha256 cellar: :any_skip_relocation, big_sur:        "8130046aab1d5652bfa3e74733692240410820a86fe60173a132ddaa37e4432e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "711ce8cfc8155673bfb276132f264250e5843894680c784c04398cc74307175f"
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
