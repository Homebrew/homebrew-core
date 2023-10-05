class Uipathcli < Formula
  desc "Command-line to simplify, script and automate API calls to UiPath services"
  homepage "https://github.com/UiPath/uipathcli"
  url "https://github.com/UiPath/uipathcli.git",
      tag:      "v1.0.90",
      revision: "66f9370f6c1d92315d7a045d837d74a56e08748b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uipath")
    system "#{bin}/uipath", "autocomplete", "enable", "--shell", "bash"
  end

  test do
    output = `#{bin}/uipath orchestrator users get 2>&1`
    assert_match "Missing organization parameter!", output
  end
end
