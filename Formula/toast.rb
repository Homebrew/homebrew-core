class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.31.0.tar.gz"
  sha256 "03f766763314fd2930820a0bed8fdc3d4405a40408e9c7b74c320bf453a35a5e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a941a71fbbab8e21f41756a0d3b63e6e3ee859547cc4a99c3042cdc4485d6dd" => :catalina
    sha256 "23905ffe680fe8babd9650b0cc306ddec5ec279adfc36a41add793d571e49d8a" => :mojave
    sha256 "b02f8e3bd163f086ff3575917b9b775f61027b3ee5436de836d90f39a1f2f9c3" => :high_sierra
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
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
