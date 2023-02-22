class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.46.0.tar.gz"
  sha256 "aebf4d2a735809c5158863bef6601f71bdeae346f583dc6d92acaba06d9f9568"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "797d85e81eb1c248f8fe448d1f89eb86a474e5db5a477e9e7662bcac2f32ae73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02824b44c03f3856a50d3b8fc577b8ff046aacb9696514e8f7250752d1dbc841"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "622490ab0432554cb7886f5fd6121a3f1bc52669f64d7c76e9b23d401eed5fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "0da6895d48eb51833c588208db13ca5863cdbafee0769bdf3d8ae4bd42b539fd"
    sha256 cellar: :any_skip_relocation, monterey:       "4e79d38256ddcaefc49b40e7d73f42028e7ed291d21c4c41efeac35ae53523c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "148f86a0f1387b5193023deb9d68c70ff404113f25aff8858a79b7171859ca48"
    sha256 cellar: :any_skip_relocation, catalina:       "dbbcdd1a92a455875511df7c7db9347bd331ebc3a2867a4519df975dfdea5a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0791c34882af2a4906ad8babb2dbabef30ec4b010dce9575fbbb40022cedb47"
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
