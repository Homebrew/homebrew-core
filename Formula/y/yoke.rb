class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.21",
      revision: "3ac3267ce313c58acc80c710f9a8507dad887ce5"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70c026e644935dc09834b3ff2c54b7144c610d8d2ebf2c51884c8e5f2a75038f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9843e4491196fab61d28f0ede7de4403669993d3f14535573b18165b7227e82f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69c6c743b10618c0d52dd6d5d656334c1dadbb166c99ea875c3cd20cc4488d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad2db5e31b464fbfd887130a6e55ab888c6bec73f927874c01fe052ba1053f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aff680b271ce7cf1ef2809b41402eeb03cdb44f3eea9706e4813fca3b2c1231a"
    sha256 cellar: :any,                 x86_64_linux:  "a7c566fa55e4227bc86dc233d000f8d21887ef93762d09f0818468dd0fce7705"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
