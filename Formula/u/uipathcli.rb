class Uipathcli < Formula
  desc "Command-line to simplify, script and automate API calls to UiPath services"
  homepage "https://github.com/UiPath/uipathcli"
  url "https://github.com/UiPath/uipathcli/archive/refs/tags/v1.0.87.tar.gz"
  sha256 "7f512fd2633eee722bb3b7f58c9b2bdaf0e47af8049cfbcbd258b80557ad7602"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uipath")
    bin.install "definitions"
    system "#{bin}/uipath", "autocomplete", "enable", "--shell", "bash"
  end

  test do
    output = `#{bin}/uipath orchestrator users get 2>&1`
    assert_match "Missing organization parameter!", output
  end
end
