class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.16.tar.gz"
  sha256 "08b7082ff900c7ec61905d954b7025dc6f780c23c81f2f13e200b2bbd7a2ef9c"
  license "MIT"
  head "https://github.com/zquestz/s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "04e743860f3014288e42d7194b2d34b88b30dbdf0d47b1362181e87e67ef3585"
    sha256 cellar: :any_skip_relocation, big_sur:       "3271073adc7ffccc4835afde6ccf5d1098181b064e4ae761a7052e24bd7e1212"
    sha256 cellar: :any_skip_relocation, catalina:      "218f0203ae8164d878fc80e678c9b726f812c80f9b6b56462e73d6216993ab91"
    sha256 cellar: :any_skip_relocation, mojave:        "da6d5042d9afbf3b6d313f4defe2b055e268e3049f013fe791e3624367853601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53bf8ba8f98766b256717d2c300035e6a9fa15880a7b85e44dcc0bae0075ac39"
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
