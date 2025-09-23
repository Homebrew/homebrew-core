class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "6d93d31bd853075724c3fd59da60d79d0007624ce7944ebbd8892fb983bf98b4"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1718395223088a32ac61b1c857e0478e965bd7c9369996dfac1a644b607a522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6cb13782c25bbbda6269823ee8aac256d81f1be684ecc505fd24de8187c7456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6218cdcab4ed4848cc71537a3928742c79e782824f59f96a8b9b24233355e765"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37cb3503e9a3df2266e0bf01626e41eb58c5163fc8f14404b715451e924a65bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9181db87052b945441756d407f00d12ec09b6ca0d723fc41334d517a5fcb247"
    sha256 cellar: :any_skip_relocation, ventura:       "73440c0b893382090f119ee322ed1f20832256686e21d971c4049f511ef9a4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650b7c485b234bff04e433269b2ef679ba3fb6c7431bb8dd36e7560a2c8b31bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
