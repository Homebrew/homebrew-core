class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.27",
      revision: "6f82f7e3ac46d3ef4ef915df59b9b6d008110118"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8fc07f1d9bd4d11e2540eecb6e634433efd62cdb40b4f75bdfee3cb7405a66a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e4859f8886b3a464d0f70efe9cc10b4ad06fb337cfa4040371a5145a7f7867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea6c6bd1d8d22cd74d50192b473357473c7eb231dae083a12c31a1a2762ec68"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ded8cf0e51af6630731bd2d62df9f8445e4cab98972c1e4eaaef5fedf49f4d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b98b34023df08429deb48d821bc5d1bf79bc3ce5a071888e858cbc29c2c79b23"
    sha256 cellar: :any,                 x86_64_linux:  "a094264d9e044f5ae646bb9aee013b115ae68a324b3a1caccceab87ce602bad3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
