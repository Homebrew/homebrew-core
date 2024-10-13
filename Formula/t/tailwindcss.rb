class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.13.tar.gz"
  sha256 "3ac83895e2351bac12479eaa1d4dffd5d6a929c82757521cbabbfebed85933da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613ebe03c67b2f4c3f88a696b68cee1b723bc90378b2422fa563aa9b30c8bc2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "613ebe03c67b2f4c3f88a696b68cee1b723bc90378b2422fa563aa9b30c8bc2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32f5fa0824ad4027ae85cb375ac51d11a7de54dfb1f959bc4d4aaedf0f3d550b"
    sha256 cellar: :any_skip_relocation, sonoma:        "121a3221bf548cc96ba10aff24cec95222c962030e8c5cdd55cb4c3b104df972"
    sha256 cellar: :any_skip_relocation, ventura:       "b1dd365c794395f682186b495f8dc9eaa5f920eb0b63a5e972dcfe6921b35654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb09e9fabb76f2c2b4e7ce81a17e909ec97247e0e647b1b1cb71cb12b6d1d795"
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *std_npm_args(prefix: false)
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
