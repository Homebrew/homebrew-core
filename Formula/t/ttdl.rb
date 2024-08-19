class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "81a5509551e92e496c712c4bc31d6f9c234f8e74ef15e2fb7adb4ea4c5111727"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d076743d534376cf35df8a7fa098ebed82833e8fea2ad76c40cdbfad056a3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e2af86d8dd6dc045a537c7e135cee2a38a6a6a3b8e9f9c49c79e4b6d9dff5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3916f04548d75a33a4909f97bf4fe3165f2372759bb614b767c4c5c0f97c7502"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b06a2eb99a279c42de2d741aa0bf46a30d71ca00182c9357c7dac59e662fee1"
    sha256 cellar: :any_skip_relocation, ventura:        "e0d7cd83dea19ef26cec5e5f796adbbbd47ac5e16d11359cc39c457fcb660491"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6f46137a8cc0568e7c1839b81a144ed631e43c1f1f35de9c1150346b4b1558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c5b9e72c4db10b48356a2c4b65658503ff32063503c03e14a44c3bfd787e34"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
