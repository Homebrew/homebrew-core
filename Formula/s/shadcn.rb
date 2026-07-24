class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.14.1.tgz"
  sha256 "a264f1be8f1247c755e1186a0b3eba305fb581f04a4bfccf5077ea43a548256d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa009665d5c20fde99070b9c5144ba8ed76fe6855e59adeee31f7e2ed65083a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa009665d5c20fde99070b9c5144ba8ed76fe6855e59adeee31f7e2ed65083a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa009665d5c20fde99070b9c5144ba8ed76fe6855e59adeee31f7e2ed65083a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5823b87d2448035f0e759c0324c6950ce9deb7410e1b540663b2fe294fa473c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f34aec788624c7e81307e5204fe0852c1750fe2b85fb25725224776b109ce2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34aec788624c7e81307e5204fe0852c1750fe2b85fb25725224776b109ce2d1"
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
