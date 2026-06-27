class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.75.2.tgz"
  sha256 "dbbbfaaca6d2a6586d9626a6ff53150c4fd0c244c9ae6bf1b42bbe5523a98cb8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5aac8864d071f25e8ecc7ae732b73a55fb388c05ce264b7355c9214fdda252da"
    sha256 cellar: :any,                 arm64_sequoia: "db44c9caf0f482fa96948ba1cab24e4cdff9f7de0d211802f0e96a7b9b06620c"
    sha256 cellar: :any,                 arm64_sonoma:  "db44c9caf0f482fa96948ba1cab24e4cdff9f7de0d211802f0e96a7b9b06620c"
    sha256 cellar: :any,                 sonoma:        "218bc00553f57340bb4958fd8e85708eaa44d307bcd18754c1ee09ebfd88ef03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f4cee23418d67fe39c76fbf43fb2a41a06f10345ff150e564855668cd56ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3198eb27489a1d02464e2b486b16150e528e0f0318535fb14c8dbeb9036af5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end
