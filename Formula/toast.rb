class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.42.1.tar.gz"
  sha256 "91a8a30b52fef41f94c0d2ee9a2af05dbfa68e9b83f5dc5ec8c2a4ddacb199fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68a299162630252739170b49102ab7985ea7ffe9e6a14f434d0ab3ca1b32ff58"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ff8c19ea1b487773e499093de909a1c6d40d784731f8f2b6aaad73a8bafc100"
    sha256 cellar: :any_skip_relocation, catalina:      "9a391d91a99e7a483548ccbf07023c0087d3aa18e9b7509fd3efd717fc2a4e42"
    sha256 cellar: :any_skip_relocation, mojave:        "af0532ad1a71b42659e64e9ce0e84c41f44b6e427fc11b521aed146b87e43e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba118fdcb028880926872f4c6cd945426236769f09c41dc72d331ea414c3275"
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
