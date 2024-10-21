class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.14.tar.gz"
  sha256 "557402050815f41713dc9fe5a1ae6b46cc0fd7b475a2b2ff48d3f1627a7d1279"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492512f372c4c46fd489972ebd01b30239a098467f80ad71afaf9f756e53313c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "492512f372c4c46fd489972ebd01b30239a098467f80ad71afaf9f756e53313c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9c8643999d40c2e4b535f2734978e89998d0c6519168ec90feb6bf04ffae6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "447ae48225cb80487b90b798c36744bda64f371e601d04271512bb7d50cbf697"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8ca0f7752f65a764f69e1bc598762d4f52227549f374995bb6a7646563da20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3db0bf07d285003a3ca2384533f182cc3991e9372dd0594783d5f381b157fd9"
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
