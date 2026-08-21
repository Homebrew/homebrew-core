class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.18.0.tgz"
  sha256 "6c3436ebc08a0b3cf13966b10647e76f3ba0796e33ced5999e6c5a7ed0526218"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91c1dde3c6b6777f725033dd58731cb651d87a236025743201d38fed61cab7a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91c1dde3c6b6777f725033dd58731cb651d87a236025743201d38fed61cab7a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c1dde3c6b6777f725033dd58731cb651d87a236025743201d38fed61cab7a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec6051338de5348f4bc638f0daaba651e403bc258c2ed989ce8e1562e6841a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd599bfd5592c52cc3a65235f59cf4c1bb73b4590f70d6a953ab946a31e0ab69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd599bfd5592c52cc3a65235f59cf4c1bb73b4590f70d6a953ab946a31e0ab69"
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
