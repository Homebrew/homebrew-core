class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-7.0.1.tgz"
  sha256 "466f653547a99ae4cf0de84beac13b8a882804f56718d81df3a2327343bbf7f4"
  license "BSD-2-Clause"
  head "https://github.com/yeoman/yo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b7987d0debf1e8b671ef5e14dbf896466c1cd55baefdb61c803f43f36ebc103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b7987d0debf1e8b671ef5e14dbf896466c1cd55baefdb61c803f43f36ebc103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b7987d0debf1e8b671ef5e14dbf896466c1cd55baefdb61c803f43f36ebc103"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7987d0debf1e8b671ef5e14dbf896466c1cd55baefdb61c803f43f36ebc103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac90a9d6b066420569c8568fc7a06372c3bba0d5d97ec019edc139eca8753599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac90a9d6b066420569c8568fc7a06372c3bba0d5d97ec019edc139eca8753599"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
    assert_match "Couldn't find any generators", shell_output("#{bin}/yo --generators")
    assert_match "Running sanity checks on your system", shell_output("#{bin}/yo doctor")
  end
end
