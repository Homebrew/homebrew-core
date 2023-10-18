class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "1e512a03dbe863516519d4fbffcc77f0aeca4ffc22522c4751969584e40d3fd5"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dec519cf53018e6a2bf533b5670246e8016f2a83eb645d4cc4aa5d5fec2de713"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8770ea5cf2998654e3784e8d992bf8b1be79a93474d31db228acf12bbf84123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b50ad58ca30be7974c89e8ad64a022f9a68b11097c6bde2b9588f5029227991"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e52a9356ecae6cd1082b1995045bd45eb48e9cae1eb4762761055adf7004745"
    sha256 cellar: :any_skip_relocation, ventura:        "f440f902a5028fd6fc761125bfdf837759db63e012a2bf7377631bd5cc946480"
    sha256 cellar: :any_skip_relocation, monterey:       "2df229d293398d0cbc727a46698785dbc208d94bb45095f016e95946bf3e7e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344610bfd84525ae227200d1d8abc5cf07f1cb6d5ca40e384cff5a7add7515fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
