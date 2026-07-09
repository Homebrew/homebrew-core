class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.13.0.tgz"
  sha256 "372fca61fc23c3c8568f1dddb311813467428edc248b43bb82904f4248a4450f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaa5f8cdc5a746acc49ddb90f4d1bbe443fb4d09375477bee985992128c29054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa5f8cdc5a746acc49ddb90f4d1bbe443fb4d09375477bee985992128c29054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa5f8cdc5a746acc49ddb90f4d1bbe443fb4d09375477bee985992128c29054"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c8541942fe975717bdb254660a471a80e53ab54d788d70feae4ac885d53727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a08b0cab3824e9ef2c427cb5f90e15bbbdec9037dca78bb880cb27da90ca4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a08b0cab3824e9ef2c427cb5f90e15bbbdec9037dca78bb880cb27da90ca4b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
