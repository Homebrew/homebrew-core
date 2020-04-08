class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.31.0.tar.gz"
  sha256 "03f766763314fd2930820a0bed8fdc3d4405a40408e9c7b74c320bf453a35a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f46a065bf8537af0afb8a38659db2caabc76a0aa8efbaa05fce46c96d6b87b7f" => :catalina
    sha256 "468e2416718f0cf2340ac5ceec225499fbda20d5ee3bb0f9097426f8d4da0ca2" => :mojave
    sha256 "5676a564359d95160f81166ce541ff43971fa628d9e44c5745d37fc51a0bf3d2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
