class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.15.tar.gz"
  sha256 "d697da32c050d026983a9696d14dace8926838eef9f491937a4f14215b674c6a"
  license "MIT"
  head "https://github.com/zquestz/s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0fcc72c7263a2e83acaa27f872c2ad2b077599264395b7b58d430a04e402eb19"
    sha256 cellar: :any_skip_relocation, big_sur:       "477cae54c3f7a8914298f8a06b890b0ecf62be4fa8281691ac5c636880968706"
    sha256 cellar: :any_skip_relocation, catalina:      "cd7352e1c4092774fdd4cbff61bd107e6447ea00e96ec94431dcbc1be7bbade5"
    sha256 cellar: :any_skip_relocation, mojave:        "04281fb66e28cf23c3ea1cd23ec6286432191fde31ac8c7b6c9c13bc6b365b0a"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4a0c5595943e8b7b4892ff3caf4d03b29533405a411268a77e0a51272a3d7823"
    sha256 cellar: :any_skip_relocation, sierra:        "b9d547b1bcc45516396ed8398b624ac83a1c4ade7bf13f130b1b063b9aec1590"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
    mv bin/"s-search", bin/"s"

    bash_completion.install "autocomplete/s-completion.bash"
    fish_completion.install "autocomplete/s.fish"
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
