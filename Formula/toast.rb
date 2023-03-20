class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.46.2.tar.gz"
  sha256 "e094964e798b86aedd8a2ddeed1ff52e8166a455b231aec8ac82b2123ad5c0ab"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b2535c0596f786bd8653c58d076218e1ca49d366d9270f746a895ed1067da01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63a32266ffe2cdcb5c008dc82f3205bdebc4e69e02d44cb7072a7f2a3ea3189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835d84729962b9687be4d1cf0d17c266a6c0ee8eb065ec183c36b915103129c5"
    sha256 cellar: :any_skip_relocation, ventura:        "c52d9b8edf572852d001f8860da1a0b959586703bf8dd76fd06a38bd9fa8b8e6"
    sha256 cellar: :any_skip_relocation, monterey:       "69c49f14672be57a6f59b4132d65ef7aee7a7b9cf7db891a381e514a143af729"
    sha256 cellar: :any_skip_relocation, big_sur:        "742b437da041ce809b44dc61d99b197e851757b76b490887bed4093d1ff1d8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e908a719006a96e1051f7002897f4206a800abd887bd35a7c59716973288b0a"
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
