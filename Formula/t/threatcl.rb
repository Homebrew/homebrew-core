class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "0f4b73b4ae878ba1be624c3089c51fcbb298548f160ab26f52412e1407d762c8"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e497682ed959de11b926acb83dbae171570044a7e53fefd5a3d387c42e2155b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506db8b6b2f9dee428b700fe7ab43f1de1327e3d84e4911d1c3a2ec84cc82c88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d94034e5b346ef3ffe5243a6f667948b1d776e1162c75e891f867e5a15842c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8f00ecbe796c5ac8e7e10b9a0698bf1fbbc54d2a699cd7df04c325d5e1eae23"
    sha256 cellar: :any_skip_relocation, ventura:       "53bf7140cabf4bfbc3672693135078f6f371018af67a71a6c2087eb603d86b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80a355421d8d42280c76963720be6f75846e7aed77ddde545cc07ababff58d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacd0a15abb6284ed16f0be1ddae2dac8833aeb571d4ad159284a09069815113"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
