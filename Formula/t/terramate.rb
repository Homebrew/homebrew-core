class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "942a81e449dbfec56ec7b31b2668bbfb1268d3b20f94914af1be317df3862fae"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c789fae3226d80864687f6a44163bfd66df03a577ae671cc13bb708f7dda5fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4627942b1196805ca5defb7bf54cdda2065f0cfdf0515ee3c3abfeaba6ae2723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e611e94306c7c4fea0f0e365e5f547c2637e3358145b4bbb4ae058497a0e760f"
    sha256 cellar: :any_skip_relocation, sonoma:         "90c0dfe5351ccf8e57e030f9fa759574a5484f59e6aa46467c873d7c6259c8ed"
    sha256 cellar: :any_skip_relocation, ventura:        "6714a3b7e5c8455d379e283429f8064a04e56ba5ff9ae1ca9df863438044e286"
    sha256 cellar: :any_skip_relocation, monterey:       "c226ffde2cdae495bf139080b2af21159e816ec90bf663ee8162b798e2efca48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ee47a36e6bc4b759db6861d3fe91fa1c0329d1b75c66867257fcb9d6ee1384"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
