class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "0f4ee7faaaf1d211123f4ac1a8107737da7539d1201d9bdb8390060b7d3887dd"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a3d90ad798c1746a43e5ceab2dd1573d9c9bda485c835be8a58bb5869fd8699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a73a500bb6e2c99e1a6b644fb23e327e8b4f5c33216e9c30ec0ee1cc26a0065c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "563a1bb91796ce25bc6678cc184b205e5c89ef03d8179262f395945ffd5fe4dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e2be62554acd599578e087ef1abb7cf5a13f7d80316abcd3d977e1c666a4fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "0dd27d4723553ab8f281000ef7842c5e603d5b09900d92a2ad833b1d393c5839"
    sha256 cellar: :any_skip_relocation, monterey:       "62296c6c1de13be8354d6d55dc14e4b46c31596c8ac13a31749b16fb773f5d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c782121a0643d96778345175b1cc6faf1ff17d20a42581925a33abe37625cc7"
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
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
