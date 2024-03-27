require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "649f0bac61fdf669c617729911cc361e42c89d5d2d62f1ce88ee147b09a79006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e154af12f0f5f8a58abeb7508a986bff29e0f27e2a7347a6fce368b4f0895e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce297889888069ff0dba3a08c93bc927ee2786adc752fa4ff59c3c89b0865ee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce297889888069ff0dba3a08c93bc927ee2786adc752fa4ff59c3c89b0865ee0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c95d320b0f4b3d7710eab9f4a0982b28028270759e5dea4eca06470ed10bf697"
    sha256 cellar: :any_skip_relocation, ventura:        "71c946215a212407e3682deb3fe4b90dbc97b735b3aaf6bea3ed6f75350c8b68"
    sha256 cellar: :any_skip_relocation, monterey:       "71c946215a212407e3682deb3fe4b90dbc97b735b3aaf6bea3ed6f75350c8b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd10944bfdf72ef219f840b30c8463d81223614c3a2c13386560be837823f14"
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
