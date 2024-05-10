require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "1ce3e9a1c9eab518e2739b7fdb5cba5fca64ebc68159b0ba50cfd94b80a79ed3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd880d54f8e6ee096ac228a88f704cb9216b4b54f3deb8b51f81e831dfe1c3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f6350cadbcf20c3deac1c71c323b6204a3e8702ea1827bed40e9810684b8969"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6350cadbcf20c3deac1c71c323b6204a3e8702ea1827bed40e9810684b8969"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bd95adaf8e306063b66323cea1dd3310caf266ad11164154795a73b81b7179c"
    sha256 cellar: :any_skip_relocation, ventura:        "2717802d66d24bb409f880d5df82c15c62a5adf592bb2c9d962cbabd900264a6"
    sha256 cellar: :any_skip_relocation, monterey:       "2717802d66d24bb409f880d5df82c15c62a5adf592bb2c9d962cbabd900264a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad500bf2338aecdf7c3c822302dc562d93a5759685c77f6c7146b87003b2eaf"
  end

  depends_on "node" => :build

  def install
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
