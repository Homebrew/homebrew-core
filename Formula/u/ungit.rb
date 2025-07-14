class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.28.tgz"
  sha256 "51f2e120f7b4ceb88ff19c7debf77877d50363f15df07d2df1235257387858af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfd52fb0ffc9a61cd102d33728d26059f661b6a9b70e723cf5378e9bf5afd082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd52fb0ffc9a61cd102d33728d26059f661b6a9b70e723cf5378e9bf5afd082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfd52fb0ffc9a61cd102d33728d26059f661b6a9b70e723cf5378e9bf5afd082"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee759a9c1cea66c47c0b2be863683ae8b67d3f65f6627e850c478c3a5e032a1e"
    sha256 cellar: :any_skip_relocation, ventura:       "ee759a9c1cea66c47c0b2be863683ae8b67d3f65f6627e850c478c3a5e032a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122896c7430c84b1086d09b9a762fab35eb8d589a0049429e8447cbcc8ae2923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd52fb0ffc9a61cd102d33728d26059f661b6a9b70e723cf5378e9bf5afd082"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 15

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
