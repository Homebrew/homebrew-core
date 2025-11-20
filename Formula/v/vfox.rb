class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "22e2024248c4faecd5d85db77f1870b4c7e6c9cc2d509d38371e6a520cd6f25b"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68dad5b1f82ddb8ca869516d57f3845e22a9aa436615902ed1310764bb45664d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77789be346d4e7a969f1484a28921ef1dee97811fc46643479f677d74c46f11e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb214e3bf897289c3066be0fedfe0bcfe74c3b0d08cb19edd55d13f88102a45b"
    sha256 cellar: :any_skip_relocation, sonoma:        "604cae55002f43e41e8bbd6a4479f5777b3fe6a424b7ceb2f656a6f4c986f177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b697ba448e0db318201a7255ebc51cb736f5f4b1b967c635e11b6c39d9ac26de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5086636b415c128dce5da08260946951b22a7a2c529454a3ea67d0ee66926792"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
