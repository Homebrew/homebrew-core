require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "f971697be21ebda8f34e641936306eaf110be20501f3b2d03cb9fcd899515248"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b8c56f40a943eea754581620255e498a673ee2be9ac16b3bdf3898120fceb4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340685c1dd22161185295afca34f7cb825af070b2dddd45436c15e60842babd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "340685c1dd22161185295afca34f7cb825af070b2dddd45436c15e60842babd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f000314ae8d53b73fa20ca5142cf77a8c5115a1ea251342df060deba17e5ad7"
    sha256 cellar: :any_skip_relocation, ventura:        "e4489921009ac3cfce688804bd6f9394c5246e08289df7e5581ef2b3f7a406b1"
    sha256 cellar: :any_skip_relocation, monterey:       "e4489921009ac3cfce688804bd6f9394c5246e08289df7e5581ef2b3f7a406b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f52eb3367a72cffc44deb8035c44f764fe7b49646b27a29353d91e36846e2e"
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
