class Taskline < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://github.com/perryrh0dan/taskline"
  url "https://registry.npmjs.org/@perryrh0dan/taskline/-/taskline-1.6.0.tgz"
  sha256 "b27122b0578c6890342ec3742ef14f89aca4315853282f982c1b6dad6b6faba2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d576ef1ca2c0ee5e1ced0ad1b08e0222452947519a8bcdf4e21da04c0be262d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d576ef1ca2c0ee5e1ced0ad1b08e0222452947519a8bcdf4e21da04c0be262d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d576ef1ca2c0ee5e1ced0ad1b08e0222452947519a8bcdf4e21da04c0be262d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d576ef1ca2c0ee5e1ced0ad1b08e0222452947519a8bcdf4e21da04c0be262d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f337709b217bdd3a8e7a82e6f352908a812dec109976faf6ad1fc8eca8e4609f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f337709b217bdd3a8e7a82e6f352908a812dec109976faf6ad1fc8eca8e4609f"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@perryrh0dan/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tl --version")

    assert_match "Available Boards:", shell_output("#{bin}/tl boards")
  end
end
