class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.47.4.tar.gz"
  sha256 "1a210546819cb5c989b8d9ea6ba2f2f773141c5b158be7a81657e8ca243f49d5"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e82de73170a88e831def0ef77a45dc18de82d6007e95fb538c123443837e4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e02c32a754ff7c6c7d73bcb6e47c1ff311e9d06ccdc905ed61ae795c32dbab9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4294bcee5c83eee079a17bebf0f80f72ab93134148594901f1f2c76fee27a005"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9fe8417afdb7f47faaae5efc4668e999486ed0af76f52112e2e397497fb626"
    sha256 cellar: :any_skip_relocation, monterey:       "421591aac30096745852da2ac87407338cf358ac4321c5e8a7e4eb6cd98db822"
    sha256 cellar: :any_skip_relocation, big_sur:        "0141660df54de234306c77bf39221ab964b21126c4fdb8b89180f8d87cbc3b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79cc7ea22ed92e274167ca450910b2779d9098b8a90c3305bf0ab33623aeb789"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
