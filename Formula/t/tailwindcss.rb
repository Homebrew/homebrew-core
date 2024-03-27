require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "649f0bac61fdf669c617729911cc361e42c89d5d2d62f1ce88ee147b09a79006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07592ca984c58d3f7ec0f8d24822e056dcfc7887daa36df863df71e03139363b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c267905b8fb5ba2091410c363badc8b383da42632c280eb0a998d12fc7d8ca3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c267905b8fb5ba2091410c363badc8b383da42632c280eb0a998d12fc7d8ca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cd717bf09834489527c774529ee81f17b9ea4551a57c0813273fa368a28a487"
    sha256 cellar: :any_skip_relocation, ventura:        "4cd1733c1a6f29b38a662bf55b9ce4cbda15fbdb86ceb5ba84f7558e2c9efe46"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd1733c1a6f29b38a662bf55b9ce4cbda15fbdb86ceb5ba84f7558e2c9efe46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f81bfd58ab4836f971a419febe29a46b1e83dbb79f1b357e6196b80f20549f"
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
