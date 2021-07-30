class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.16.tar.gz"
  sha256 "08b7082ff900c7ec61905d954b7025dc6f780c23c81f2f13e200b2bbd7a2ef9c"
  license "MIT"
  head "https://github.com/zquestz/s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7352ae6c698d5ba53f7e1cb73962e4fb35a0ab0e4c251049516268ceb0c96ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb100ff43d035ef125fbaba324bff3173249825ff7defb2aadf6696b5a79ad98"
    sha256 cellar: :any_skip_relocation, catalina:      "83cd7b0c28cd0d03cd46df22bfcf48394fdcaba87f206e221752f926c7375810"
    sha256 cellar: :any_skip_relocation, mojave:        "0c1c930da14bc0dd0f01778b949b94d1344bb213ed8f33cdbef7b62fbdd11175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73db5ab0e21a2668d6f9380a58ca72a3769c2c9bc0c3086976b2ed6cfd98835"
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
