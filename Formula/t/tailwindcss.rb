require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "99156755e55d7bb3d02d4288c5f5182375bf5ef8fb2299228138bee5d43d1de2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e498c5f092a02de12800d2c5f9f776d63d74701fd952841b4a83474bfbf14730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ade0b679d24183e1fbdf9caf51414a65dacf0f284b3a0efef4ada1c955cbf9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ade0b679d24183e1fbdf9caf51414a65dacf0f284b3a0efef4ada1c955cbf9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e563d0fb0f3933e976d406e31457bdc611eede145d9ff85521445b63dd8a80b"
    sha256 cellar: :any_skip_relocation, ventura:        "630b9094873c291b0f9dbcb06ceba63b1048cb5159400b1ee5d823078390ba60"
    sha256 cellar: :any_skip_relocation, monterey:       "4eeb7cc1e6eff5452f377f635ca61785b67bd34787b1fc1b632af116b0a7d69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4429dd1dbf7ff0172966cf32b0c3178b3e159925f6b59ef0a907ddafcd6ee219"
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
